Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CD031A002
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 14:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhBLNo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 08:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhBLNo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 08:44:56 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E47C061756;
        Fri, 12 Feb 2021 05:44:15 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lAYju-001rVv-Rg; Fri, 12 Feb 2021 14:44:06 +0100
Message-ID: <ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Fri, 12 Feb 2021 14:44:05 +0100
In-Reply-To: <20210212115030.124490-1-srini.raju@purelifi.com> (sfid-20210212_125300_396085_B8C8E2C0)
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20210212115030.124490-1-srini.raju@purelifi.com>
         (sfid-20210212_125300_396085_B8C8E2C0)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your patience, and thanks for sticking around!

I'm sorry I haven't reviewed this again in a long time, but I was able
to today.


> +PUREILIFI USB DRIVER

Did you mistype "PURELIFI" here, or was that intentional?

> +PUREILIFI USB DRIVER
> +M:	Srinivasan Raju <srini.raju@purelifi.com>

Probably would be good to have an "L" entry with the linux-wireless list
here.

> +if WLAN_VENDOR_PURELIFI
> +
> +source "drivers/net/wireless/purelifi/plfxlc/Kconfig"

Seems odd to have the Makefile under purelifi/ but the Kconfig is yet
another directory deeper?

> +++ b/drivers/net/wireless/purelifi/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_WLAN_VENDOR_PURELIFI)		:= plfxlc/

Although this one doesn't do anything, so all you did was save a level
of Kconfig inclusion I guess ... no real objection to that.

> diff --git a/drivers/net/wireless/purelifi/plfxlc/Kconfig b/drivers/net/wireless/purelifi/plfxlc/Kconfig
> new file mode 100644
> index 000000000000..07a65c0fce68
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/plfxlc/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config PLFXLC
> +
> +	tristate "pureLiFi X, XL, XC device support"

extra blank line.

Also, maybe that should be a bit more verbose? PURELIFI_XLC or so? I
don't think it shows up in many places, but if you see "PLFXLC"
somewhere that's not very helpful.

> +	depends on CFG80211 && MAC80211 && USB
> +	help
> +	   This driver makes the adapter appear as a normal WLAN interface.
> +
> +	   The pureLiFi device requires external STA firmware to be loaded.
> +
> +	   To compile this driver as a module, choose M here: the module will
> +	   be called purelifi.

But will it? Seems like it would be called "plfxlc"?

See here:

> +++ b/drivers/net/wireless/purelifi/plfxlc/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_PLFXLC)		:= plfxlc.o
> +plfxlc-objs 		+= chip.o firmware.o usb.o mac.o


> +int purelifi_set_beacon_interval(struct purelifi_chip *chip, u16 interval,
> +				 u8 dtim_period, int type)
> +{
> +	if (!interval ||
> +	    (chip->beacon_set && chip->beacon_interval == interval)) {
> +		return 0;
> +	}

Don't need braces here

> +	chip->beacon_interval = interval;
> +	chip->beacon_set = true;
> +	return usb_write_req((const u8 *)&chip->beacon_interval,
> +			     sizeof(chip->beacon_interval),
> +			     USB_REQ_BEACON_INTERVAL_WR);

There's clearly an endian problem hiding here somewhere. You should have
"chip->beacon_interval" be (probably) __le16 since you send it to the
device as a buffer, yet the parameter to this function is just "u16".
Therefore, a conversion is missing somewhere - likely you need it to be
__le16 in the chip struct since you can't send USB requests from stack.


You should add some annotations for things getting sent to the device
like this, and then you can run sparse to validate them all over the
code.


> +}
> +
> +int purelifi_chip_init_hw(struct purelifi_chip *chip)
> +{
> +	u8 *addr = purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip));
> +	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
> +
> +	pr_info("purelifi chip %02x:%02x v%02x  %02x-%02x-%02x %s\n",

"%04x:%04x" for the USB ID?

And you should probably use %pM for the MAC address - the format you
have there looks ... strange? Why only print the vendor OUI?

> +int purelifi_chip_switch_radio(struct purelifi_chip *chip, u32 value)
> +{
> +	int r;
> +
> +	r = usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_POWER_WR);
> +	if (r)
> +		dev_err(purelifi_chip_dev(chip), "POWER_WR failed (%d)\n", r);

Same endian problem here.

> 
> +static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,
> +					u8 *addr)
> +{
> +	unsigned int i = addr[5] >> 2;
> +
> +	if (i < 32)
> +		hash->low |= 1 << i;
> +	else
> +		hash->high |= 1 << (i - 32);

That's UB if i == 31, you need 1U << i, or just use the BIT() macro.

> +	r = request_firmware((const struct firmware **)&fw, fw_name,

Not sure why that cast should be required?

> +	fpga_dmabuff = NULL;
> +	fpga_dmabuff = kmalloc(PLF_FPGA_SLEN, GFP_KERNEL);

that NULL assignment is pointless :)

> +
> +	if (!fpga_dmabuff) {
> +		r = -ENOMEM;
> +		goto error_free_fw;
> +	}
> +	send_vendor_request(udev, PLF_VNDR_FPGA_SET_REQ, fpga_dmabuff, sizeof(fpga_setting));
> +	memcpy(fpga_setting, fpga_dmabuff, PLF_FPGA_SLEN);
> +	kfree(fpga_dmabuff);

I'd say you should remove fpga_setting from the stack since you anyway
allocated it, save the memcpy() to the stack, and just use fpga_dmabuff
below - and then free it later?

> +		for (tbuf_idx = 0; tbuf_idx < blk_tran_len; tbuf_idx++) {
> +			/* u8 bit reverse */
> +			fw_data[tbuf_idx] =
> +				((fw_data[tbuf_idx] & 128) >> 7) |
> +				((fw_data[tbuf_idx] &  64) >> 5) |
> +				((fw_data[tbuf_idx] &  32) >> 3) |
> +				((fw_data[tbuf_idx] &  16) >> 1) |
> +				((fw_data[tbuf_idx] &   8) << 1) |
> +				((fw_data[tbuf_idx] &   4) << 3) |
> +				((fw_data[tbuf_idx] &   2) << 5) |
> +				((fw_data[tbuf_idx] &   1) << 7);
> +		}

check out include/linux/bitrev.h and bitrev8().

> +	fpga_dmabuff = NULL;
> +	fpga_dmabuff = kmalloc(PLF_FPGA_ST_LEN, GFP_KERNEL);

again useless NULL assignment

> +	if (!fpga_dmabuff) {
> +		r = -ENOMEM;
> +		goto error_free_fw;
> +	}
> +	memset(fpga_dmabuff, 0xFF, PLF_FPGA_ST_LEN);

does it have to be 0xff? Maybe kzalloc() would be shorter?

> +	send_vendor_request(udev, PLF_VNDR_FPGA_STATE_REQ, fpga_dmabuff,
> +			    sizeof(fpga_state));
> +
> +	dev_dbg(&intf->dev, "fpga status: %x %x %x %x %x %x %x %x\n",
> +		fpga_dmabuff[0], fpga_dmabuff[1],
> +		fpga_dmabuff[2], fpga_dmabuff[3],
> +		fpga_dmabuff[4], fpga_dmabuff[5],
> +		fpga_dmabuff[6], fpga_dmabuff[7]);

consider something like
	dev_dbg(..., "%*ph\n", 8, fpga_dmabuff);

to simplify this.

> +	if (fpga_dmabuff[0] != 0) {
> +		r = -EINVAL;
> +		kfree(fpga_dmabuff);
> +		goto error_free_fw;

you have an out label anyway, make it free fpga_dmabuff too? kfree(NULL)
is OK, so you can just always do that there.

> +	no_of_files = *(u32 *)&fw_packed->data[0];

All of this is completely endianness broken, and quite possibly also has
alignment problems. Need get_unaligned_le32() I guess.

> +	for (step = 0; step < no_of_files; step++) {
> +		buf[0] = step;
> +		r = send_vendor_command(udev, PLF_VNDR_XL_FILE_CMD, buf,
> +					PLF_XL_BUF_LEN);
> +
> +		if (step < no_of_files - 1)
> +			size = *(u32 *)&fw_packed->data[4 + ((step + 1) * 4)]
> +				- *(u32 *)&fw_packed->data[4 + (step) * 4];
> +		else
> +			size = tot_size -
> +				*(u32 *)&fw_packed->data[4 + (step) * 4];
> +
> +		start_addr = *(u32 *)&fw_packed->data[4 + (step * 4)];

Lots of those here too - you might want to define a struct with __le32
entries for some of this stuff so sparse can validate your assumptions
("make C=1").

Also, you *really* need some validation here, rather than blindly
trusting that the file is well-formed, otherwise you immediately have a
security issue here.

> +#define PLF_MAC_VENDOR_REQUEST 0x36
> +#define PLF_SERIAL_NUMBER_VENDOR_REQUEST 0x37
> +#define PLF_FIRMWARE_VERSION_VENDOR_REQUEST 0x39
> +#define PLF_SERIAL_LEN 14
> +#define PLF_FW_VER_LEN 8
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	int r = 0;
> +	unsigned char *dma_buffer = NULL;
> +	unsigned long long firmware_version;
> +
> +	dma_buffer = kmalloc(PLF_SERIAL_LEN, GFP_KERNEL);

I'd probably throw in a few build assertions such as

	BUILD_BUG_ON(ETH_ALEN > PLF_SERIAL_LEN);
	BUILD_BUG_ON(PLF_FW_VER_LEN > PLF_SERIAL_LEN);

> +	if (!dma_buffer) {
> +		r = -ENOMEM;
> +		goto error;

you do nothing at the error label, might as well remove it

and then you can remove the 'r' variable

> +struct rx_status {
> +	u16 rssi;
> +	u8  rate_idx;
> +	u8  pad;
> +	u64 crc_error_count;
> +} __packed;

endian issues, I assume

> +struct usb_req_t {
> +	enum usb_req_enum_t id;
> +	u32            len;
> +	u8             buf[512];
> +};

quite possibly here too, but dunno. Not sure I'd rely on 'enum' to have
a specific size here, and anyway the enum here will basically make the
sparse endian annotations impossible - better use __le32 with a comment
pointing to the enum.

> +static const struct plf_reg_alpha2_map reg_alpha2_map[] = {
> +	{ PLF_REGDOMAIN_FCC, "US" },
> +	{ PLF_REGDOMAIN_IC, "CA" },
> +	{ PLF_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
> +	{ PLF_REGDOMAIN_JAPAN, "JP" },
> +	{ PLF_REGDOMAIN_SPAIN, "ES" },
> +	{ PLF_REGDOMAIN_FRANCE, "FR" },
> +};

You actually have regulatory restrictions on this stuff?

> +static const struct ieee80211_rate purelifi_rates[] = {
> +	{ .bitrate = 10,
> +		.hw_value = PURELIFI_CCK_RATE_1M,
> +		.flags = 0 },
> +	{ .bitrate = 20,
> +		.hw_value = PURELIFI_CCK_RATE_2M,
> +		.hw_value_short = PURELIFI_CCK_RATE_2M
> +			| PURELIFI_CCK_PREA_SHORT,
> +		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 55,
> +		.hw_value = PURELIFI_CCK_RATE_5_5M,
> +		.hw_value_short = PURELIFI_CCK_RATE_5_5M
> +			| PURELIFI_CCK_PREA_SHORT,
> +		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 110,
> +		.hw_value = PURELIFI_CCK_RATE_11M,
> +		.hw_value_short = PURELIFI_CCK_RATE_11M
> +			| PURELIFI_CCK_PREA_SHORT,
> +		.flags = IEEE80211_RATE_SHORT_PREAMBLE },

So ... how much of that is completely fake? Are you _actually_ doing 1,
2, 5.5 etc. Mbps over the air, and you even have short and long
preamble? Why do all of that legacy mess, when you're essentially
greenfield??

> +
> +static const struct ieee80211_channel purelifi_channels[] = {
> +	{ .center_freq = 2412, .hw_value = 1 },
> +	{ .center_freq = 2417, .hw_value = 2 },
> +	{ .center_freq = 2422, .hw_value = 3 },
> +	{ .center_freq = 2427, .hw_value = 4 },
> +	{ .center_freq = 2432, .hw_value = 5 },
> +	{ .center_freq = 2437, .hw_value = 6 },
> +	{ .center_freq = 2442, .hw_value = 7 },
> +	{ .center_freq = 2447, .hw_value = 8 },
> +	{ .center_freq = 2452, .hw_value = 9 },
> +	{ .center_freq = 2457, .hw_value = 10 },
> +	{ .center_freq = 2462, .hw_value = 11 },
> +	{ .center_freq = 2467, .hw_value = 12 },
> +	{ .center_freq = 2472, .hw_value = 13 },
> +	{ .center_freq = 2484, .hw_value = 14 },
> +};
> +
> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
> +				      struct sk_buff *beacon, bool in_intr);
> +
> +static int plf_reg2alpha2(u8 regdomain, char *alpha2)
> +{
> +	unsigned int i;
> +	const struct plf_reg_alpha2_map *reg_map;
> +		for (i = 0; i < ARRAY_SIZE(reg_alpha2_map); i++) {

indentation is off here, and a blank line after the variables would be
nice

> +int purelifi_mac_preinit_hw(struct ieee80211_hw *hw, unsigned char *hw_address)

const u8 *?

> +void block_queue(struct purelifi_usb *usb, const u8 *mac, bool block)

Why is there a mac argument to this?

> +	dev_dbg(purelifi_mac_dev(mac), "irq_disabled (%d)\n", irqs_disabled());
> +	r = plf_reg2alpha2(mac->regdomain, alpha2);
> +	r = regulatory_hint(hw->wiphy, alpha2);

that first assignment to r is unused?

> +/**
> + * purelifi_mac_tx_status - reports tx status of a packet if required
> + * @hw - a &struct ieee80211_hw pointer
> + * @skb - a sk-buffer

bad kernel doc format I believe, and you do use : below:

> + * @flags: extra flags to set in the TX status info
> + * @ackssi: ACK signal strength
> + * @success - True for successful transmission of the frame

just not always :)

> + * This information calls ieee80211_tx_status_irqsafe() if required by the
> + * control information. It copies the control information into the status
> + * information.
> + *
> + * If no status information has been requested, the skb is freed.

That last line doesn't seem true?

> +	} else {
> +		/* ieee80211_tx_status_irqsafe(hw, skb); */

?

> +static int purelifi_mac_config_beacon(struct ieee80211_hw *hw,
> +				      struct sk_buff *beacon, bool in_intr)

unused in_intr arg?

> +	if (skb_headroom(skb) < sizeof(struct purelifi_ctrlset)) {
> +		dev_dbg(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
> +		return 1;
> +	}
> +
> +	cs = (struct purelifi_ctrlset *)skb_push(skb,
> +			sizeof(struct purelifi_ctrlset));

FWIW, (void *) cast is sufficient

> +	cs->id = USB_REQ_DATA_TX;
> +	cs->payload_len_nw = frag_len;
> +	cs->len = cs->payload_len_nw + sizeof(struct purelifi_ctrlset)
> +		- sizeof(cs->id) - sizeof(cs->len);

the - at the end of line is generally preferred, but not really that
important I guess

> +	/*check if 32 bit aligned and align data*/
> +	tmp = skb->len & 3;
> +	if (tmp) {
> +		if (skb_tailroom(skb) < (3 - tmp)) {
> +			if (skb_headroom(skb) >= 4 - tmp) {
> +				u8 len;
> +				u8 *src_pt;
> +				u8 *dest_pt;
> +
> +				len = skb->len;
> +				src_pt = skb->data;
> +				dest_pt = skb_push(skb, 4 - tmp);
> +				memcpy(dest_pt, src_pt, len);

that can overlap, so you really need memmove(), not memcpy().

> +			} else {
> +				return 1;

return 1 is "unidiomatic" in the kernel, maybe just return -ENOBUFS?

> +				/* should never happen b/c

wouldn't hurt to spell that out ;)

> +				 * sufficient headroom was reserved
> +				 */
> +				return 1;

same here

> +static void purelifi_op_tx(struct ieee80211_hw *hw,
> +			   struct ieee80211_tx_control *control,
> +			   struct sk_buff *skb)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_usb *usb = &mac->chip.usb;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	unsigned long flags;
> +	int r;
> +
> +	r = fill_ctrlset(mac, skb);
> +	if (r)
> +		goto fail;
> +	info->rate_driver_data[0] = hw;
> +
> +	if (skb->data[24] == IEEE80211_FTYPE_DATA) {

it would be much clearer if you had a struct that you overlay on top of
the struct and then you have something like

	struct purelifi_header *plhdr = (void *)skb->data;

	if (plhdr->frametype == IEEE80211_FTYPE_DATA)

here.

Assuming that's what it does? Otherwise it doesn't make much sense?

It's not obvious what the SKB contains at this point, having a struct
there would make it obvious.

> +		u8 dst_mac[ETH_ALEN];
> +		u8 sidx;
> +		bool found = false;
> +		struct purelifi_usb_tx *tx = &usb->tx;
> +
> +		memcpy(dst_mac, &skb->data[28], ETH_ALEN);

Why copy it to the stack first?

> +		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
> +			if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
> +				continue;
> +			if (!memcmp(tx->station[sidx].mac, dst_mac, ETH_ALEN)) {

you haven't changed the skb?

And if you wanted it for line length or something, then just use a
pointer? Again though, the data[28] probably should be some struct
dereference.

> +				found = true;
> +				break;
> +			}
> +		}
> +
> +		/* Default to broadcast address for unknown MACs */
> +		if (!found)
> +			sidx = STA_BROADCAST_INDEX;
> +
> +		/* Stop OS from sending packets, if the queue is half full */
> +		if (skb_queue_len(&tx->station[sidx].data_list) > 60)
> +			block_queue(usb, tx->station[sidx].mac, true);
> +
> +		/* Schedule packet for transmission if queue is not full */
> +		if (skb_queue_len(&tx->station[sidx].data_list) < 256) {

60/256 isn't really half, but hey :)

> +			skb_queue_tail(&tx->station[sidx].data_list, skb);
> +			purelifi_send_packet_from_data_queue(usb);
> +		} else {
> +			dev_kfree_skb(skb);

It's kind of strangely inconsistent that you have here a free and then
fall through to the return, but other times you a 'goto fail':

> +		}
> +	} else {
> +		spin_lock_irqsave(&usb->tx.lock, flags);
> +		r = usb_write_req_async(&mac->chip.usb, skb->data, skb->len,
> +					USB_REQ_DATA_TX, tx_urb_complete, skb);
> +		spin_unlock_irqrestore(&usb->tx.lock, flags);
> +		if (r)
> +			goto fail;
> +	}
> +	return;
> +
> +fail:
> +	dev_kfree_skb(skb);

where you free it

> +static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
> +		      struct ieee80211_rx_status *stats)

Generally, it'd be nice if more of your functions came with some prefix,
like say plf_filter_ack() in this case.

> +int purelifi_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
> +		    unsigned int length)

or, well, purelifi_ :)

> +	crc_error_cnt_low = status->crc_error_count;
> +	crc_error_cnt_high = status->crc_error_count >> 32;
> +	mac->crc_errors = ((u64)ntohl(crc_error_cnt_low) << 32) |
> +		ntohl(crc_error_cnt_high);

Oh hey, I found one place where you do endian conversion ;-)

but ... what's wrong with be64_to_cpu()?

> +	if (buffer[0] == IEEE80211_STYPE_PROBE_REQ)
> +		dev_dbg(purelifi_mac_dev(mac), "Probe request\n");
> +	else if (buffer[0] == IEEE80211_STYPE_ASSOC_REQ)
> +		dev_dbg(purelifi_mac_dev(mac), "Association request\n");
> +
> +	if (buffer[0] == IEEE80211_STYPE_AUTH) {
> +		dev_dbg(purelifi_mac_dev(mac), "Authentication req\n");
> +		min_exp_seq_nmb = 0;
> +	} else if (buffer[0] == IEEE80211_FTYPE_DATA) {

maybe a switch statement would be better anyway, but this "interrupted
else-if chain" looks really weird.

Not sure I'd add any of this in the first place

> +		unsigned short int seq_nmb = (buffer[23] << 4) |
> +			((buffer[22] & 0xF0) >> 4);
> +
> +		if (seq_nmb < min_exp_seq_nmb &&
> +		    ((min_exp_seq_nmb - seq_nmb) < 3000)) {
> +			dev_dbg(purelifi_mac_dev(mac), "seq_nmb < min_exp\n");
> +		} else {
> +			min_exp_seq_nmb = (seq_nmb + 1) % 4096;
> +		}

don't need braces

> +	memcpy(skb_put(skb, payload_length), buffer, payload_length);

skb_put_data()

> +	hw = ieee80211_alloc_hw(sizeof(struct purelifi_mac), &purelifi_ops);
> +	if (!hw) {
> +		dev_dbg(&intf->dev, "out of memory\n");
> +		return NULL;
> +	}
> +	set_wiphy_dev(hw->wiphy, &intf->dev);
> +
> +	mac = purelifi_hw_mac(hw);
> +
> +	memset(mac, 0, sizeof(*mac));

no need, we use kzalloc() internally.

> +	hw->wiphy->bands[NL80211_BAND_2GHZ] = &mac->band;

This is kind of the only fundamental problem I have with this ... are we
really sure we want this to pretend to be 2.4 GHz? You only have a
single channel anyway, and you pretend that's a fixed one (somewhere
above, I skipped it)...

But it really has absolutely no relation to 2.4 GHz!

OTOH, I can sort of see why/how you're reusing wifi functionality here,
very old versions of wifi even had an infrared PHY I think.

Conceptually, it seems odd. Perhaps we should add a new band definition?

And what I also asked above - how much of the rate stuff is completely
fake? Are you really doing CCK/OFDM in some (strange?) way?

> +	_ieee80211_hw_set(hw, IEEE80211_HW_RX_INCLUDES_FCS);
> +	_ieee80211_hw_set(hw, IEEE80211_HW_SIGNAL_DBM);
> +	_ieee80211_hw_set(hw, IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING);
> +	_ieee80211_hw_set(hw, IEEE80211_HW_MFP_CAPABLE);

Why not use the macro?

> +	hw->extra_tx_headroom = sizeof(struct purelifi_ctrlset) + 4;

Ah, so you _do_ have a struct for all this header stuff! Please use it
where I pointed it out above.

> +struct purelifi_ctrlset {
> +	enum usb_req_enum_t id;
> +	u32            len;
> +	u8             modulation;
> +	u8             control;
> +	u8             service;
> +	u8             pad;
> +	__le16         packet_length;
> +	__le16         current_length;
> +	__le16          next_frame_length;
> +	__le16         tx_length;
> +	u32            payload_len_nw;

having a mix of __le32 and u32 seems weird :)

but not sure you ever even converted things, did you run sparse with
"make C=1"?

> +struct purelifi_mac {
> +	struct purelifi_chip chip;
> +	spinlock_t lock; /* lock for mac data */
> +	spinlock_t intr_lock; /* not used : interrupt lock for mac */

well, remove it if it's not used?

> +	/* whether to pass frames with CRC errors to stack */
> +	unsigned int pass_failed_fcs:1;
> +
> +	/* whether to pass control frames to stack */
> +	unsigned int pass_ctrl:1;
> +
> +	/* whether we have received a 802.11 ACK that is pending */
> +	bool ack_pending:1;

bool bitfield looks really odd ... what does that even do? I think
better use unsigned int like above.

> +static inline struct purelifi_mac *purelifi_chip_to_mac(struct purelifi_chip
> +		*chip)

I'd recommend writing that as

static inline struct ... *
purelifi_chip_to_mac(...)


> +#ifdef DEBUG
> +void purelifi_dump_rx_status(const struct rx_status *status);
> +#else
> +#define purelifi_dump_rx_status(status)

do {} while (0)

> +#define FCS_LEN 4

might want to reuse FCS_LEN from ieee80211.h, i.e. just remove this?

> +struct proc_dir_entry *proc_folder;
> +struct proc_dir_entry *modulation_proc_entry;

You really need to remove procfs stuff, even these traces ;-)

> +	switch (urb->status) {
> +	case 0:
> +		break;
> +	case -ESHUTDOWN:
> +	case -EINVAL:
> +	case -ENODEV:
> +	case -ENOENT:
> +	case -ECONNRESET:
> +	case -EPIPE:
> +		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
> +		return;
> +	default:
> +		dev_dbg(urb_dev(urb), "urb %p error %d\n", urb, urb->status);
> +		goto resubmit;

you might want to limit that resubmit loop here to a few attempts

> +	buffer = urb->transfer_buffer;
> +	length = (*(u32 *)(buffer + sizeof(struct rx_status))) + sizeof(u32);

endian issues

> +	kfree(urbs);
> +
> +	spin_lock_irqsave(&rx->lock, flags);
> +	rx->urbs = NULL;
> +	rx->urbs_count = 0;
> +	spin_unlock_irqrestore(&rx->lock, flags);

That looks ... really weird, first you free and then you assign the
pointer to NULL, but under the lock?

I guess the lock is completely pointless here.

> +void purelifi_usb_release(struct purelifi_usb *usb)
> +{
> +	usb_set_intfdata(usb->intf, NULL);
> +	usb_put_intf(usb->intf);
> +	/* FIXME: usb_interrupt, usb_tx, usb_rx? */

what about them?

> +	dma_buffer = kzalloc(usb_bulk_msg_len, GFP_KERNEL);
> +
> +	if (!dma_buffer) {
> +		r = -ENOMEM;
> +		goto error;
> +	}
> +	memcpy(dma_buffer, &usb_req, usb_bulk_msg_len);

kmemdup()


> +static int pre_reset(struct usb_interface *intf)
> +{
> +	struct ieee80211_hw *hw = usb_get_intfdata(intf);
> +	struct purelifi_mac *mac;
> +	struct purelifi_usb *usb;
> +
> +	if (!hw || intf->condition != USB_INTERFACE_BOUND)
> +		return 0;
> +
> +	mac = purelifi_hw_mac(hw);
> +	usb = &mac->chip.usb;
> +
> +	usb->was_running = test_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
> +
> +	purelifi_usb_stop(usb);
> +
> +	mutex_lock(&mac->chip.mutex);

this looks kind of problematic locking-wise

> +static int post_reset(struct usb_interface *intf)
> +{
> +	struct ieee80211_hw *hw = usb_get_intfdata(intf);
> +	struct purelifi_mac *mac;
> +	struct purelifi_usb *usb;
> +
> +	if (!hw || intf->condition != USB_INTERFACE_BOUND)
> +		return 0;

especially since this doesn't always unlock?

Not sure intf->condition can change inbetween, but it looks very
fragile.

> +#define TO_NETWORK(X) ((((X) & 0xFF000000) >> 24) | (((X) & 0xFF0000) >> 8) |\
> +		      (((X) & 0xFF00) << 8) | (((X) & 0xFF) << 24))
> +
> +#define TO_NETWORK_16(X) ((((X) & 0xFF00) >> 8) | (((X) & 0x00FF) << 8))
> +
> +#define TO_NETWORK_32(X) TO_NETWORK(X)
> +
> +#define TO_HOST(X)    TO_NETWORK(X)
> +#define TO_HOST_16(X) TO_NETWORK_16(X)
> +#define TO_HOST_32(X) TO_NETWORK_32(X)

Remove all of that.

> +static inline struct usb_device *purelifi_usb_to_usbdev(struct purelifi_usb
> +		*usb)

indentation per above comment

johannes

