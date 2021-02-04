Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B270730FEB8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 21:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhBDUoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 15:44:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:29079 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhBDUoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 15:44:20 -0500
IronPort-SDR: iYKKjIn1m6qX5EGUPlzSXJL56iPzdSQMncWCAw3nNZB97Ia7rk+7VsW85qouh0MiURTJFTm4pe
 E1MX8m2Q8cFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="245396625"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="245396625"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 12:43:16 -0800
IronPort-SDR: Iz9w13Y2LMiREBYg3WMOGyVK0IkjB0XkhCuEbxriPbS9FU9vrudHixUollab7vMQoppwzTrzuf
 RDfihtqjaAsg==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="434105793"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 12:43:15 -0800
Date:   Thu, 4 Feb 2021 12:43:14 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/9] lan78xx: add NAPI interface support
Message-ID: <20210204124314.00007907@intel.com>
In-Reply-To: <20210204113121.29786-2-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
        <20210204113121.29786-2-john.efstathiades@pebblebay.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NB: I thought I'd have a close look at this since I thought I
understand NAPI pretty well, but using NAPI to transmit frames as well
as with a usb device has got me pretty confused. Also, I suspect that
you didn't try compiling this against the net-next kernel.

I'm stopping my review only partially completed, please address issues
https://patchwork.kernel.org/project/netdevbpf/patch/20210204113121.29786-2-john.efstathiades@pebblebay.com/

It might make it easier for reviewers to split the "infrastructure"
refactors this patch uses into separate pieces. I know it is more work
and this is tested already by you, but this is a pretty complicated
chunk of code to review.

John Efstathiades wrote:

> Improve driver throughput and reduce CPU overhead by using the NAPI
> interface for processing Rx packets and scheduling Tx and Rx URBs.
> 
> Provide statically-allocated URB and buffer pool for both Tx and Rx
> packets to give greater control over resource allocation.
> 
> Remove modification of hard_header_len that prevents correct operation
> of generic receive offload (GRO) handling of TCP connections.
> 
> Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
> ---
>  drivers/net/usb/lan78xx.c | 1176 ++++++++++++++++++++++++-------------
>  1 file changed, 775 insertions(+), 401 deletions(-)
> 
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index e81c5699c952..1c872edc816a 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -47,17 +47,17 @@
>  
>  #define MAX_RX_FIFO_SIZE		(12 * 1024)
>  #define MAX_TX_FIFO_SIZE		(12 * 1024)
> -#define DEFAULT_BURST_CAP_SIZE		(MAX_TX_FIFO_SIZE)
> -#define DEFAULT_BULK_IN_DELAY		(0x0800)
>  #define MAX_SINGLE_PACKET_SIZE		(9000)
>  #define DEFAULT_TX_CSUM_ENABLE		(true)
>  #define DEFAULT_RX_CSUM_ENABLE		(true)
>  #define DEFAULT_TSO_CSUM_ENABLE		(true)
>  #define DEFAULT_VLAN_FILTER_ENABLE	(true)
>  #define DEFAULT_VLAN_RX_OFFLOAD		(true)
> -#define TX_OVERHEAD			(8)
> +#define TX_ALIGNMENT			(4)
>  #define RXW_PADDING			2
>  
> +#define MIN_IPV4_DGRAM			68
> +
>  #define LAN78XX_USB_VENDOR_ID		(0x0424)
>  #define LAN7800_USB_PRODUCT_ID		(0x7800)
>  #define LAN7850_USB_PRODUCT_ID		(0x7850)
> @@ -78,6 +78,44 @@
>  					 WAKE_MCAST | WAKE_BCAST | \
>  					 WAKE_ARP | WAKE_MAGIC)
>  
> +#define LAN78XX_NAPI_WEIGHT		64
> +
> +#define TX_URB_NUM			10
> +#define TX_SS_URB_NUM			TX_URB_NUM
> +#define TX_HS_URB_NUM			TX_URB_NUM
> +#define TX_FS_URB_NUM			TX_URB_NUM
> +
> +/* A single URB buffer must be large enough to hold a complete jumbo packet
> + */
> +#define TX_SS_URB_SIZE			(32 * 1024)

wow, 32k per allocation! Only 30 of them I guess.

> +#define TX_HS_URB_SIZE			(16 * 1024)
> +#define TX_FS_URB_SIZE			(10 * 1024)
> +
> +#define RX_SS_URB_NUM			30
> +#define RX_HS_URB_NUM			10
> +#define RX_FS_URB_NUM			10
> +#define RX_SS_URB_SIZE			TX_SS_URB_SIZE
> +#define RX_HS_URB_SIZE			TX_HS_URB_SIZE
> +#define RX_FS_URB_SIZE			TX_FS_URB_SIZE
> +
> +#define SS_BURST_CAP_SIZE		RX_SS_URB_SIZE
> +#define SS_BULK_IN_DELAY		0x2000
> +#define HS_BURST_CAP_SIZE		RX_HS_URB_SIZE
> +#define HS_BULK_IN_DELAY		0x2000
> +#define FS_BURST_CAP_SIZE		RX_FS_URB_SIZE
> +#define FS_BULK_IN_DELAY		0x2000
> +
> +#define TX_CMD_LEN			8
> +#define TX_SKB_MIN_LEN			(TX_CMD_LEN + ETH_HLEN)
> +#define LAN78XX_TSO_SIZE(dev)		((dev)->tx_urb_size - TX_SKB_MIN_LEN)
> +
> +#define RX_CMD_LEN			10
> +#define RX_SKB_MIN_LEN			(RX_CMD_LEN + ETH_HLEN)
> +#define RX_MAX_FRAME_LEN(mtu)		((mtu) + ETH_HLEN + VLAN_HLEN)
> +
> +#define LAN78XX_MIN_MTU			MIN_IPV4_DGRAM
> +#define LAN78XX_MAX_MTU			MAX_SINGLE_PACKET_SIZE
> +
>  /* USB related defines */
>  #define BULK_IN_PIPE			1
>  #define BULK_OUT_PIPE			2
> @@ -366,15 +404,22 @@ struct lan78xx_net {
>  	struct usb_interface	*intf;
>  	void			*driver_priv;
>  
> -	int			rx_qlen;
> -	int			tx_qlen;
> +	int			tx_pend_data_len;
> +	int			n_tx_urbs;
> +	int			n_rx_urbs;
> +	int			rx_urb_size;
> +	int			tx_urb_size;
> +
> +	struct sk_buff_head	rxq_free;
> +	struct sk_buff_head	rxq_overflow;
> +	struct sk_buff_head	rxq_done;
>  	struct sk_buff_head	rxq;
> +	struct sk_buff_head	txq_free;
>  	struct sk_buff_head	txq;
> -	struct sk_buff_head	done;
> -	struct sk_buff_head	rxq_pause;
>  	struct sk_buff_head	txq_pend;
>  
> -	struct tasklet_struct	bh;
> +	struct napi_struct	napi;
> +
>  	struct delayed_work	wq;
>  
>  	int			msg_enable;
> @@ -385,16 +430,15 @@ struct lan78xx_net {
>  	struct mutex		phy_mutex; /* for phy access */
>  	unsigned		pipe_in, pipe_out, pipe_intr;
>  
> -	u32			hard_mtu;	/* count any extra framing */
> -	size_t			rx_urb_size;	/* size for rx urbs */
> +	unsigned int		bulk_in_delay;
> +	unsigned int		burst_cap;
>  
>  	unsigned long		flags;
>  
>  	wait_queue_head_t	*wait;
>  	unsigned char		suspend_count;
>  
> -	unsigned		maxpacket;
> -	struct timer_list	delay;
> +	unsigned int		maxpacket;
>  	struct timer_list	stat_monitor;
>  
>  	unsigned long		data[5];
> @@ -425,6 +469,128 @@ static int msg_level = -1;
>  module_param(msg_level, int, 0);
>  MODULE_PARM_DESC(msg_level, "Override default message level");
>  
> +static inline struct sk_buff *lan78xx_get_buf(struct sk_buff_head *buf_pool)
> +{
> +	if (!skb_queue_empty(buf_pool))
> +		return skb_dequeue(buf_pool);
> +	else
> +		return NULL;
> +}
> +
> +static inline void lan78xx_free_buf(struct sk_buff_head *buf_pool,
> +				    struct sk_buff *buf)
> +{
> +	buf->data = buf->head;
> +	skb_reset_tail_pointer(buf);
> +	buf->len = 0;
> +	buf->data_len = 0;
> +
> +	skb_queue_tail(buf_pool, buf);
> +}
> +
> +static void lan78xx_free_buf_pool(struct sk_buff_head *buf_pool)
> +{
> +	struct sk_buff *buf;
> +	struct skb_data *entry;
> +
> +	while (!skb_queue_empty(buf_pool)) {
> +		buf = skb_dequeue(buf_pool);
> +		if (buf) {
> +			entry = (struct skb_data *)buf->cb;
> +			usb_free_urb(entry->urb);
> +			dev_kfree_skb_any(buf);
> +		}
> +	}
> +}
> +
> +static int lan78xx_alloc_buf_pool(struct sk_buff_head *buf_pool,
> +				  int n_urbs, int urb_size,
> +				  struct lan78xx_net *dev)
> +{
> +	int i;
> +	struct sk_buff *buf;
> +	struct skb_data *entry;
> +	struct urb *urb;
> +
> +	skb_queue_head_init(buf_pool);
> +
> +	for (i = 0; i < n_urbs; i++) {
> +		buf = alloc_skb(urb_size, GFP_ATOMIC);
> +		if (!buf)
> +			goto error;
> +
> +		if (skb_linearize(buf) != 0) {
> +			dev_kfree_skb_any(buf);
> +			goto error;
> +		}

Why did you need to do the linearize? The alloc_skb should never give
you back a fragmented data area. You're only paying the linearize cost
during pool create, so that's good, but I still wonder why it's
necessary?

> +
> +		urb = usb_alloc_urb(0, GFP_ATOMIC);
> +		if (!urb) {
> +			dev_kfree_skb_any(buf);
> +			goto error;
> +		}
> +
> +		entry = (struct skb_data *)buf->cb;
> +		entry->urb = urb;
> +		entry->dev = dev;
> +		entry->length = 0;
> +		entry->num_of_packet = 0;
> +
> +		skb_queue_tail(buf_pool, buf);
> +	}
> +
> +	return 0;
> +
> +error:
> +	lan78xx_free_buf_pool(buf_pool);
> +
> +	return -ENOMEM;
> +}
> +
> +static inline struct sk_buff *lan78xx_get_rx_buf(struct lan78xx_net *dev)
> +{
> +	return lan78xx_get_buf(&dev->rxq_free);
> +}
> +
> +static inline void lan78xx_free_rx_buf(struct lan78xx_net *dev,
> +				       struct sk_buff *rx_buf)
> +{
> +	lan78xx_free_buf(&dev->rxq_free, rx_buf);
> +}
> +
> +static void lan78xx_free_rx_resources(struct lan78xx_net *dev)
> +{
> +	lan78xx_free_buf_pool(&dev->rxq_free);
> +}
> +
> +static int lan78xx_alloc_rx_resources(struct lan78xx_net *dev)
> +{
> +	return lan78xx_alloc_buf_pool(&dev->rxq_free,
> +				      dev->n_rx_urbs, dev->rx_urb_size, dev);
> +}
> +
> +static inline struct sk_buff *lan78xx_get_tx_buf(struct lan78xx_net *dev)
> +{
> +	return lan78xx_get_buf(&dev->txq_free);
> +}
> +
> +static inline void lan78xx_free_tx_buf(struct lan78xx_net *dev,
> +				       struct sk_buff *tx_buf)
> +{
> +	lan78xx_free_buf(&dev->txq_free, tx_buf);
> +}
> +
> +static void lan78xx_free_tx_resources(struct lan78xx_net *dev)
> +{
> +	lan78xx_free_buf_pool(&dev->txq_free);
> +}
> +
> +static int lan78xx_alloc_tx_resources(struct lan78xx_net *dev)
> +{
> +	return lan78xx_alloc_buf_pool(&dev->txq_free,
> +				      dev->n_tx_urbs, dev->tx_urb_size, dev);
> +}
> +
>  static int lan78xx_read_reg(struct lan78xx_net *dev, u32 index, u32 *data)
>  {
>  	u32 *buf = kmalloc(sizeof(u32), GFP_KERNEL);
> @@ -1135,7 +1301,7 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
>  		flow |= FLOW_CR_RX_FCEN_;
>  
>  	if (dev->udev->speed == USB_SPEED_SUPER)
> -		fct_flow = 0x817;
> +		fct_flow = 0x812;

These kind of unexplained changes of magic numbers in the middle of a
NAPI patch make me nervous.


>  	else if (dev->udev->speed == USB_SPEED_HIGH)
>  		fct_flow = 0x211;
>  
> @@ -1151,6 +1317,8 @@ static int lan78xx_update_flowcontrol(struct lan78xx_net *dev, u8 duplex,
>  	return 0;
>  }
>  
> +static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev);
> +
>  static int lan78xx_link_reset(struct lan78xx_net *dev)
>  {
>  	struct phy_device *phydev = dev->net->phydev;
> @@ -1223,7 +1391,9 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
>  				  jiffies + STAT_UPDATE_TIMER);
>  		}
>  
> -		tasklet_schedule(&dev->bh);
> +		lan78xx_rx_urb_submit_all(dev);
> +
> +		napi_schedule(&dev->napi);
>  	}
>  
>  	return ret;
> @@ -2196,7 +2366,8 @@ static int lan78xx_set_rx_max_frame_length(struct lan78xx_net *dev, int size)
>  
>  	/* add 4 to size for FCS */
>  	buf &= ~MAC_RX_MAX_SIZE_MASK_;
> -	buf |= (((size + 4) << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
> +	buf |= (((size + ETH_FCS_LEN) << MAC_RX_MAX_SIZE_SHIFT_) &
> +		MAC_RX_MAX_SIZE_MASK_);

comment above no longer applies?

>  
>  	lan78xx_write_reg(dev, MAC_RX, buf);
>  
> @@ -2256,28 +2427,26 @@ static int unlink_urbs(struct lan78xx_net *dev, struct sk_buff_head *q)
>  static int lan78xx_change_mtu(struct net_device *netdev, int new_mtu)
>  {
>  	struct lan78xx_net *dev = netdev_priv(netdev);
> -	int ll_mtu = new_mtu + netdev->hard_header_len;
> -	int old_hard_mtu = dev->hard_mtu;
> -	int old_rx_urb_size = dev->rx_urb_size;
> +	int max_frame_len = RX_MAX_FRAME_LEN(new_mtu);
> +	int ret;
> +
> +	if (new_mtu < LAN78XX_MIN_MTU ||
> +	    new_mtu > LAN78XX_MAX_MTU)
> +		return -EINVAL;
>  
>  	/* no second zero-length packet read wanted after mtu-sized packets */
> -	if ((ll_mtu % dev->maxpacket) == 0)
> +	if ((max_frame_len % dev->maxpacket) == 0)
>  		return -EDOM;
>  
> -	lan78xx_set_rx_max_frame_length(dev, new_mtu + VLAN_ETH_HLEN);
> +	ret = usb_autopm_get_interface(dev->intf);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = lan78xx_set_rx_max_frame_length(dev, max_frame_len);
>  
>  	netdev->mtu = new_mtu;
>  

Shouldn't this just be using the new min_mtu/max_mtu stuff? These kind
of changes should have been in a separate patch, they have nothing to
do with NAPI conversion...

> -	dev->hard_mtu = netdev->mtu + netdev->hard_header_len;
> -	if (dev->rx_urb_size == old_hard_mtu) {
> -		dev->rx_urb_size = dev->hard_mtu;
> -		if (dev->rx_urb_size > old_rx_urb_size) {
> -			if (netif_running(dev->net)) {
> -				unlink_urbs(dev, &dev->rxq);
> -				tasklet_schedule(&dev->bh);
> -			}
> -		}
> -	}
> +	usb_autopm_put_interface(dev->intf);
>  
>  	return 0;
>  }
> @@ -2435,6 +2604,44 @@ static void lan78xx_init_ltm(struct lan78xx_net *dev)
>  	lan78xx_write_reg(dev, LTM_INACTIVE1, regs[5]);
>  }
>  
> +static int lan78xx_urb_config_init(struct lan78xx_net *dev)
> +{
> +	int result = 0;
> +
> +	switch (dev->udev->speed) {
> +	case USB_SPEED_SUPER:
> +		dev->rx_urb_size = RX_SS_URB_SIZE;
> +		dev->tx_urb_size = TX_SS_URB_SIZE;
> +		dev->n_rx_urbs = RX_SS_URB_NUM;
> +		dev->n_tx_urbs = TX_SS_URB_NUM;
> +		dev->bulk_in_delay = SS_BULK_IN_DELAY;
> +		dev->burst_cap = SS_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
> +		break;
> +	case USB_SPEED_HIGH:
> +		dev->rx_urb_size = RX_HS_URB_SIZE;
> +		dev->tx_urb_size = TX_HS_URB_SIZE;
> +		dev->n_rx_urbs = RX_HS_URB_NUM;
> +		dev->n_tx_urbs = TX_HS_URB_NUM;
> +		dev->bulk_in_delay = HS_BULK_IN_DELAY;
> +		dev->burst_cap = HS_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
> +		break;
> +	case USB_SPEED_FULL:
> +		dev->rx_urb_size = RX_FS_URB_SIZE;
> +		dev->tx_urb_size = TX_FS_URB_SIZE;
> +		dev->n_rx_urbs = RX_FS_URB_NUM;
> +		dev->n_tx_urbs = TX_FS_URB_NUM;
> +		dev->bulk_in_delay = FS_BULK_IN_DELAY;
> +		dev->burst_cap = FS_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
> +		break;
> +	default:
> +		netdev_warn(dev->net, "USB bus speed not supported\n");
> +		result = -EIO;
> +		break;
> +	}
> +
> +	return result;
> +}
> +
>  static int lan78xx_reset(struct lan78xx_net *dev)
>  {
>  	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
> @@ -2473,25 +2680,8 @@ static int lan78xx_reset(struct lan78xx_net *dev)
>  	/* Init LTM */
>  	lan78xx_init_ltm(dev);
>  
> -	if (dev->udev->speed == USB_SPEED_SUPER) {
> -		buf = DEFAULT_BURST_CAP_SIZE / SS_USB_PKT_SIZE;
> -		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
> -		dev->rx_qlen = 4;
> -		dev->tx_qlen = 4;
> -	} else if (dev->udev->speed == USB_SPEED_HIGH) {
> -		buf = DEFAULT_BURST_CAP_SIZE / HS_USB_PKT_SIZE;
> -		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
> -		dev->rx_qlen = RX_MAX_QUEUE_MEMORY / dev->rx_urb_size;
> -		dev->tx_qlen = RX_MAX_QUEUE_MEMORY / dev->hard_mtu;
> -	} else {
> -		buf = DEFAULT_BURST_CAP_SIZE / FS_USB_PKT_SIZE;
> -		dev->rx_urb_size = DEFAULT_BURST_CAP_SIZE;
> -		dev->rx_qlen = 4;
> -		dev->tx_qlen = 4;
> -	}
> -
> -	ret = lan78xx_write_reg(dev, BURST_CAP, buf);
> -	ret = lan78xx_write_reg(dev, BULK_IN_DLY, DEFAULT_BULK_IN_DELAY);
> +	ret = lan78xx_write_reg(dev, BURST_CAP, dev->burst_cap);
> +	ret = lan78xx_write_reg(dev, BULK_IN_DLY, dev->bulk_in_delay);
>  
>  	ret = lan78xx_read_reg(dev, HW_CFG, &buf);
>  	buf |= HW_CFG_MEF_;
> @@ -2501,6 +2691,8 @@ static int lan78xx_reset(struct lan78xx_net *dev)
>  	buf |= USB_CFG_BCE_;
>  	ret = lan78xx_write_reg(dev, USB_CFG0, buf);
>  
> +	netdev_info(dev->net, "USB_CFG0 0x%08x\n", buf);
> +
>  	/* set FIFO sizes */
>  	buf = (MAX_RX_FIFO_SIZE - 512) / 512;
>  	ret = lan78xx_write_reg(dev, FCT_RX_FIFO_END, buf);
> @@ -2561,7 +2753,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
>  	ret = lan78xx_write_reg(dev, FCT_TX_CTL, buf);
>  
>  	ret = lan78xx_set_rx_max_frame_length(dev,
> -					      dev->net->mtu + VLAN_ETH_HLEN);
> +					      RX_MAX_FRAME_LEN(dev->net->mtu));
>  
>  	ret = lan78xx_read_reg(dev, MAC_RX, &buf);
>  	buf |= MAC_RX_RXEN_;
> @@ -2600,6 +2792,8 @@ static void lan78xx_init_stats(struct lan78xx_net *dev)
>  	set_bit(EVENT_STAT_UPDATE, &dev->flags);
>  }
>  
> +static int rx_submit(struct lan78xx_net *dev, struct sk_buff *rx_buf, gfp_t flags);
> +
>  static int lan78xx_open(struct net_device *net)
>  {
>  	struct lan78xx_net *dev = netdev_priv(net);
> @@ -2631,6 +2825,8 @@ static int lan78xx_open(struct net_device *net)
>  
>  	dev->link_on = false;
>  
> +	napi_enable(&dev->napi);
> +
>  	lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
>  done:
>  	usb_autopm_put_interface(dev->intf);
> @@ -2639,11 +2835,14 @@ static int lan78xx_open(struct net_device *net)
>  	return ret;
>  }
>  
> +static int lan78x_tx_pend_skb_get(struct lan78xx_net *dev, struct sk_buff **skb);
> +
>  static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
>  {
>  	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
>  	DECLARE_WAITQUEUE(wait, current);
>  	int temp;
> +	struct sk_buff *skb;
>  
>  	/* ensure there are no more active urbs */
>  	add_wait_queue(&unlink_wakeup, &wait);
> @@ -2652,17 +2851,26 @@ static void lan78xx_terminate_urbs(struct lan78xx_net *dev)
>  	temp = unlink_urbs(dev, &dev->txq) + unlink_urbs(dev, &dev->rxq);
>  
>  	/* maybe wait for deletions to finish. */
> -	while (!skb_queue_empty(&dev->rxq) &&
> -	       !skb_queue_empty(&dev->txq) &&
> -	       !skb_queue_empty(&dev->done)) {
> +	while (!skb_queue_empty(&dev->rxq) ||
> +	       !skb_queue_empty(&dev->txq)) {
>  		schedule_timeout(msecs_to_jiffies(UNLINK_TIMEOUT_MS));
>  		set_current_state(TASK_UNINTERRUPTIBLE);
>  		netif_dbg(dev, ifdown, dev->net,
> -			  "waited for %d urb completions\n", temp);
> +			  "waited for %d urb completions", temp);
>  	}
>  	set_current_state(TASK_RUNNING);
>  	dev->wait = NULL;
>  	remove_wait_queue(&unlink_wakeup, &wait);
> +
> +	/* empty Rx done, Rx overflow and Tx pend queues
> +	 */

single line comment doesn't need \n before */

> +	while (!skb_queue_empty(&dev->rxq_done)) {
> +		skb = skb_dequeue(&dev->rxq_done);
> +		lan78xx_free_rx_buf(dev, skb);
> +	}
> +
> +	skb_queue_purge(&dev->rxq_overflow);
> +	skb_queue_purge(&dev->txq_pend);
>  }
>  
>  static int lan78xx_stop(struct net_device *net)
> @@ -2672,78 +2880,34 @@ static int lan78xx_stop(struct net_device *net)
>  	if (timer_pending(&dev->stat_monitor))
>  		del_timer_sync(&dev->stat_monitor);
>  
> -	if (net->phydev)
> -		phy_stop(net->phydev);
> -
>  	clear_bit(EVENT_DEV_OPEN, &dev->flags);
>  	netif_stop_queue(net);
> +	napi_disable(&dev->napi);
> +
> +	lan78xx_terminate_urbs(dev);
>  
>  	netif_info(dev, ifdown, dev->net,
>  		   "stop stats: rx/tx %lu/%lu, errs %lu/%lu\n",
>  		   net->stats.rx_packets, net->stats.tx_packets,
>  		   net->stats.rx_errors, net->stats.tx_errors);
>  
> -	lan78xx_terminate_urbs(dev);
> +	if (net->phydev)
> +		phy_stop(net->phydev);
>  
>  	usb_kill_urb(dev->urb_intr);
>  
> -	skb_queue_purge(&dev->rxq_pause);
> -
>  	/* deferred work (task, timer, softirq) must also stop.
>  	 * can't flush_scheduled_work() until we drop rtnl (later),
>  	 * else workers could deadlock; so make workers a NOP.
>  	 */
>  	dev->flags = 0;
>  	cancel_delayed_work_sync(&dev->wq);
> -	tasklet_kill(&dev->bh);
>  
>  	usb_autopm_put_interface(dev->intf);
>  
>  	return 0;
>  }
>  
> -static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
> -				       struct sk_buff *skb, gfp_t flags)
> -{
> -	u32 tx_cmd_a, tx_cmd_b;
> -	void *ptr;
> -
> -	if (skb_cow_head(skb, TX_OVERHEAD)) {
> -		dev_kfree_skb_any(skb);
> -		return NULL;
> -	}
> -
> -	if (skb_linearize(skb)) {
> -		dev_kfree_skb_any(skb);
> -		return NULL;
> -	}
> -
> -	tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
> -
> -	if (skb->ip_summed == CHECKSUM_PARTIAL)
> -		tx_cmd_a |= TX_CMD_A_IPE_ | TX_CMD_A_TPE_;
> -
> -	tx_cmd_b = 0;
> -	if (skb_is_gso(skb)) {
> -		u16 mss = max(skb_shinfo(skb)->gso_size, TX_CMD_B_MSS_MIN_);
> -
> -		tx_cmd_b = (mss << TX_CMD_B_MSS_SHIFT_) & TX_CMD_B_MSS_MASK_;
> -
> -		tx_cmd_a |= TX_CMD_A_LSO_;
> -	}
> -
> -	if (skb_vlan_tag_present(skb)) {
> -		tx_cmd_a |= TX_CMD_A_IVTG_;
> -		tx_cmd_b |= skb_vlan_tag_get(skb) & TX_CMD_B_VTAG_MASK_;
> -	}
> -
> -	ptr = skb_push(skb, 8);
> -	put_unaligned_le32(tx_cmd_a, ptr);
> -	put_unaligned_le32(tx_cmd_b, ptr + 4);
> -
> -	return skb;
> -}
> -
>  static enum skb_state defer_bh(struct lan78xx_net *dev, struct sk_buff *skb,
>  			       struct sk_buff_head *list, enum skb_state state)
>  {
> @@ -2752,17 +2916,21 @@ static enum skb_state defer_bh(struct lan78xx_net *dev, struct sk_buff *skb,
>  	struct skb_data *entry = (struct skb_data *)skb->cb;
>  
>  	spin_lock_irqsave(&list->lock, flags);
> +
>  	old_state = entry->state;
>  	entry->state = state;
>  
>  	__skb_unlink(skb, list);
> +
>  	spin_unlock(&list->lock);
> -	spin_lock(&dev->done.lock);
> +	spin_lock(&dev->rxq_done.lock);
> +
> +	__skb_queue_tail(&dev->rxq_done, skb);
> +
> +	if (skb_queue_len(&dev->rxq_done) == 1)
> +		napi_schedule(&dev->napi);
>  
> -	__skb_queue_tail(&dev->done, skb);
> -	if (skb_queue_len(&dev->done) == 1)
> -		tasklet_schedule(&dev->bh);
> -	spin_unlock_irqrestore(&dev->done.lock, flags);
> +	spin_unlock_irqrestore(&dev->rxq_done.lock, flags);
>  
>  	return old_state;
>  }
> @@ -2773,11 +2941,14 @@ static void tx_complete(struct urb *urb)
>  	struct skb_data *entry = (struct skb_data *)skb->cb;
>  	struct lan78xx_net *dev = entry->dev;
>  
> +	netif_dbg(dev, tx_done, dev->net,
> +		  "tx done: status %d\n", urb->status);
> +
>  	if (urb->status == 0) {
>  		dev->net->stats.tx_packets += entry->num_of_packet;
>  		dev->net->stats.tx_bytes += entry->length;
>  	} else {
> -		dev->net->stats.tx_errors++;
> +		dev->net->stats.tx_errors += entry->num_of_packet;
>  
>  		switch (urb->status) {
>  		case -EPIPE:
> @@ -2803,7 +2974,15 @@ static void tx_complete(struct urb *urb)
>  
>  	usb_autopm_put_interface_async(dev->intf);
>  
> -	defer_bh(dev, skb, &dev->txq, tx_done);
> +	skb_unlink(skb, &dev->txq);
> +
> +	lan78xx_free_tx_buf(dev, skb);
> +
> +	/* Re-schedule NAPI if Tx data pending but no URBs in progress.
> +	 */
> +	if (skb_queue_empty(&dev->txq) &&
> +	    !skb_queue_empty(&dev->txq_pend))
> +		napi_schedule(&dev->napi);
>  }
>  
>  static void lan78xx_queue_skb(struct sk_buff_head *list,
> @@ -2815,32 +2994,102 @@ static void lan78xx_queue_skb(struct sk_buff_head *list,
>  	entry->state = state;
>  }
>  
> +#define LAN78XX_TX_URB_SPACE(dev) (skb_queue_len(&(dev)->txq_free) * \
> +				   (dev)->tx_urb_size)
> +
> +static int lan78xx_tx_pend_data_len(struct lan78xx_net *dev)
> +{
> +	return dev->tx_pend_data_len;
> +}
> +
> +static int lan78x_tx_pend_skb_add(struct lan78xx_net *dev, struct sk_buff *skb)
> +{
> +	int tx_pend_data_len;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->txq_pend.lock, flags);
> +
> +	__skb_queue_tail(&dev->txq_pend, skb);
> +
> +	dev->tx_pend_data_len += skb->len;
> +	tx_pend_data_len = dev->tx_pend_data_len;
> +
> +	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
> +
> +	return tx_pend_data_len;
> +}
> +
> +static int lan78x_tx_pend_skb_head_add(struct lan78xx_net *dev, struct sk_buff *skb)
> +{
> +	int tx_pend_data_len;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->txq_pend.lock, flags);
> +
> +	__skb_queue_head(&dev->txq_pend, skb);
> +
> +	dev->tx_pend_data_len += skb->len;
> +	tx_pend_data_len = dev->tx_pend_data_len;
> +
> +	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
> +
> +	return tx_pend_data_len;
> +}
> +
> +static int lan78x_tx_pend_skb_get(struct lan78xx_net *dev, struct sk_buff **skb)
> +{
> +	int tx_pend_data_len;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dev->txq_pend.lock, flags);
> +
> +	*skb = __skb_dequeue(&dev->txq_pend);
> +
> +	if (*skb)
> +		dev->tx_pend_data_len -= (*skb)->len;
> +	tx_pend_data_len = dev->tx_pend_data_len;
> +
> +	spin_unlock_irqrestore(&dev->txq_pend.lock, flags);
> +
> +	return tx_pend_data_len;
> +}
> +
>  static netdev_tx_t
>  lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
>  {
> +	int tx_pend_data_len;
> +
>  	struct lan78xx_net *dev = netdev_priv(net);
> -	struct sk_buff *skb2 = NULL;
>  
> -	if (skb) {
> -		skb_tx_timestamp(skb);
> -		skb2 = lan78xx_tx_prep(dev, skb, GFP_ATOMIC);
> -	}
> +	/* Get the deferred work handler to resume the
> +	 * device if it's suspended.
> +	 */
> +	if (test_bit(EVENT_DEV_ASLEEP, &dev->flags))
> +		schedule_delayed_work(&dev->wq, 0);
>  
> -	if (skb2) {
> -		skb_queue_tail(&dev->txq_pend, skb2);
> +	skb_tx_timestamp(skb);
>  
> -		/* throttle TX patch at slower than SUPER SPEED USB */
> -		if ((dev->udev->speed < USB_SPEED_SUPER) &&
> -		    (skb_queue_len(&dev->txq_pend) > 10))
> -			netif_stop_queue(net);
> -	} else {
> -		netif_dbg(dev, tx_err, dev->net,
> -			  "lan78xx_tx_prep return NULL\n");
> -		dev->net->stats.tx_errors++;
> -		dev->net->stats.tx_dropped++;
> -	}
> +	tx_pend_data_len = lan78x_tx_pend_skb_add(dev, skb);
> +
> +	/* Set up a Tx URB if none is in progress.
> +	 */
> +	if (skb_queue_empty(&dev->txq))
> +		napi_schedule(&dev->napi);
> +
> +	/* Stop stack Tx queue if we have enough data to fill
> +	 * all the free Tx URBs.
> +	 */
> +	if (tx_pend_data_len > LAN78XX_TX_URB_SPACE(dev)) {
> +		netif_stop_queue(net);
>  
> -	tasklet_schedule(&dev->bh);
> +		netif_dbg(dev, hw, dev->net, "tx data len: %d, urb space %d\n",
> +			  tx_pend_data_len, LAN78XX_TX_URB_SPACE(dev));
> +
> +		/* Kick off transmission of pending data */
> +
> +		if (!skb_queue_empty(&dev->txq_free))
> +			napi_schedule(&dev->napi);
> +	}
>  
>  	return NETDEV_TX_OK;
>  }
> @@ -2897,9 +3146,6 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
>  		goto out1;
>  	}
>  
> -	dev->net->hard_header_len += TX_OVERHEAD;
> -	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
> -
>  	/* Init all registers */
>  	ret = lan78xx_reset(dev);
>  	if (ret) {
> @@ -2978,12 +3224,7 @@ static void lan78xx_rx_vlan_offload(struct lan78xx_net *dev,
>  
>  static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
>  {
> -	int status;
> -
> -	if (test_bit(EVENT_RX_PAUSED, &dev->flags)) {
> -		skb_queue_tail(&dev->rxq_pause, skb);
> -		return;
> -	}
> +	gro_result_t gro_result;
>  
>  	dev->net->stats.rx_packets++;
>  	dev->net->stats.rx_bytes += skb->len;
> @@ -2997,21 +3238,24 @@ static void lan78xx_skb_return(struct lan78xx_net *dev, struct sk_buff *skb)
>  	if (skb_defer_rx_timestamp(skb))
>  		return;
>  
> -	status = netif_rx(skb);
> -	if (status != NET_RX_SUCCESS)
> -		netif_dbg(dev, rx_err, dev->net,
> -			  "netif_rx status %d\n", status);
> +	gro_result = napi_gro_receive(&dev->napi, skb);
> +
> +	if (gro_result == GRO_DROP)
> +		netif_dbg(dev, rx_err, dev->net, "GRO packet dropped\n");
>  }

GRO_DROP no longer exists, what kernel did you compile test this on?
