Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159B42261D5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbgGTOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:19:48 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:47092 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTOTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:19:47 -0400
Received: from localhost.localdomain (p200300e9d7371614ec13d59c95910a08.dip0.t-ipconnect.de [IPv6:2003:e9:d737:1614:ec13:d59c:9591:a08])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2321BC0D06;
        Mon, 20 Jul 2020 16:19:38 +0200 (CEST)
Subject: Re: [PATCH 24/24] net: pass a sockptr_t into ->setsockopt
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
References: <20200720124737.118617-1-hch@lst.de>
 <20200720124737.118617-25-hch@lst.de>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <deaedc6d-edde-68da-50e8-6474ca818191@datenfreihafen.org>
Date:   Mon, 20 Jul 2020 16:19:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200720124737.118617-25-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 20.07.20 14:47, Christoph Hellwig wrote:
> Rework the remaining setsockopt code to pass a sockptr_t instead of a
> plain user pointer.  This removes the last remaining set_fs(KERNEL_DS)
> outside of architecture specific code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   crypto/af_alg.c                           |  7 ++--
>   drivers/crypto/chelsio/chtls/chtls_main.c | 18 ++++++-----
>   drivers/isdn/mISDN/socket.c               |  4 +--
>   include/linux/net.h                       |  4 ++-
>   include/net/inet_connection_sock.h        |  3 +-
>   include/net/ip.h                          |  2 +-
>   include/net/ipv6.h                        |  4 +--
>   include/net/sctp/structs.h                |  2 +-
>   include/net/sock.h                        |  4 +--
>   include/net/tcp.h                         |  4 +--
>   net/atm/common.c                          |  6 ++--
>   net/atm/common.h                          |  2 +-
>   net/atm/pvc.c                             |  2 +-
>   net/atm/svc.c                             |  6 ++--
>   net/ax25/af_ax25.c                        |  6 ++--
>   net/bluetooth/hci_sock.c                  |  8 ++---
>   net/bluetooth/l2cap_sock.c                | 22 ++++++-------
>   net/bluetooth/rfcomm/sock.c               | 12 ++++---
>   net/bluetooth/sco.c                       |  6 ++--
>   net/caif/caif_socket.c                    |  8 ++---
>   net/can/j1939/socket.c                    | 12 +++----
>   net/can/raw.c                             | 16 +++++-----
>   net/core/sock.c                           |  2 +-
>   net/dccp/dccp.h                           |  2 +-
>   net/dccp/proto.c                          | 20 ++++++------
>   net/decnet/af_decnet.c                    | 16 ++++++----
>   net/ieee802154/socket.c                   |  6 ++--
>   net/ipv4/ip_sockglue.c                    | 13 +++-----
>   net/ipv4/raw.c                            |  8 ++---
>   net/ipv4/tcp.c                            |  5 ++-
>   net/ipv4/udp.c                            |  6 ++--
>   net/ipv4/udp_impl.h                       |  4 +--
>   net/ipv6/ipv6_sockglue.c                  | 10 +++---
>   net/ipv6/raw.c                            | 10 +++---
>   net/ipv6/udp.c                            |  6 ++--
>   net/ipv6/udp_impl.h                       |  4 +--
>   net/iucv/af_iucv.c                        |  4 +--
>   net/kcm/kcmsock.c                         |  6 ++--
>   net/l2tp/l2tp_ppp.c                       |  4 +--
>   net/llc/af_llc.c                          |  4 +--
>   net/mptcp/protocol.c                      | 14 ++++----
>   net/netlink/af_netlink.c                  |  4 +--
>   net/netrom/af_netrom.c                    |  4 +--
>   net/nfc/llcp_sock.c                       |  6 ++--
>   net/packet/af_packet.c                    | 39 ++++++++++++-----------
>   net/phonet/pep.c                          |  4 +--
>   net/rds/af_rds.c                          | 30 ++++++++---------
>   net/rds/rdma.c                            | 14 ++++----
>   net/rds/rds.h                             |  6 ++--
>   net/rose/af_rose.c                        |  4 +--
>   net/rxrpc/af_rxrpc.c                      |  8 ++---
>   net/rxrpc/ar-internal.h                   |  4 +--
>   net/rxrpc/key.c                           |  9 +++---
>   net/sctp/socket.c                         |  4 +--
>   net/smc/af_smc.c                          |  4 +--
>   net/socket.c                              | 23 ++++---------
>   net/tipc/socket.c                         |  8 ++---
>   net/tls/tls_main.c                        | 17 +++++-----
>   net/vmw_vsock/af_vsock.c                  |  4 +--
>   net/x25/af_x25.c                          |  4 +--
>   net/xdp/xsk.c                             |  8 ++---
>   61 files changed, 248 insertions(+), 258 deletions(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 29f71428520b4b..892242a42c3ec9 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -197,8 +197,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>   	return err;
>   }
>   
> -static int alg_setkey(struct sock *sk, char __user *ukey,
> -		      unsigned int keylen)
> +static int alg_setkey(struct sock *sk, sockptr_t ukey, unsigned int keylen)
>   {
>   	struct alg_sock *ask = alg_sk(sk);
>   	const struct af_alg_type *type = ask->type;
> @@ -210,7 +209,7 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
>   		return -ENOMEM;
>   
>   	err = -EFAULT;
> -	if (copy_from_user(key, ukey, keylen))
> +	if (copy_from_sockptr(key, ukey, keylen))
>   		goto out;
>   
>   	err = type->setkey(ask->private, key, keylen);
> @@ -222,7 +221,7 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
>   }
>   
>   static int alg_setsockopt(struct socket *sock, int level, int optname,
> -			  char __user *optval, unsigned int optlen)
> +			  sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct alg_sock *ask = alg_sk(sk);
> diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
> index d98b89d0fa6eeb..c3058dcdb33c5c 100644
> --- a/drivers/crypto/chelsio/chtls/chtls_main.c
> +++ b/drivers/crypto/chelsio/chtls/chtls_main.c
> @@ -488,7 +488,7 @@ static int chtls_getsockopt(struct sock *sk, int level, int optname,
>   }
>   
>   static int do_chtls_setsockopt(struct sock *sk, int optname,
> -			       char __user *optval, unsigned int optlen)
> +			       sockptr_t optval, unsigned int optlen)
>   {
>   	struct tls_crypto_info *crypto_info, tmp_crypto_info;
>   	struct chtls_sock *csk;
> @@ -498,12 +498,12 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
>   
>   	csk = rcu_dereference_sk_user_data(sk);
>   
> -	if (!optval || optlen < sizeof(*crypto_info)) {
> +	if (sockptr_is_null(optval) || optlen < sizeof(*crypto_info)) {
>   		rc = -EINVAL;
>   		goto out;
>   	}
>   
> -	rc = copy_from_user(&tmp_crypto_info, optval, sizeof(*crypto_info));
> +	rc = copy_from_sockptr(&tmp_crypto_info, optval, sizeof(*crypto_info));
>   	if (rc) {
>   		rc = -EFAULT;
>   		goto out;
> @@ -525,8 +525,9 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
>   		/* Obtain version and type from previous copy */
>   		crypto_info[0] = tmp_crypto_info;
>   		/* Now copy the following data */
> -		rc = copy_from_user((char *)crypto_info + sizeof(*crypto_info),
> -				optval + sizeof(*crypto_info),
> +		sockptr_advance(optval, sizeof(*crypto_info));
> +		rc = copy_from_sockptr((char *)crypto_info + sizeof(*crypto_info),
> +				optval,
>   				sizeof(struct tls12_crypto_info_aes_gcm_128)
>   				- sizeof(*crypto_info));
>   
> @@ -541,8 +542,9 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
>   	}
>   	case TLS_CIPHER_AES_GCM_256: {
>   		crypto_info[0] = tmp_crypto_info;
> -		rc = copy_from_user((char *)crypto_info + sizeof(*crypto_info),
> -				    optval + sizeof(*crypto_info),
> +		sockptr_advance(optval, sizeof(*crypto_info));
> +		rc = copy_from_sockptr((char *)crypto_info + sizeof(*crypto_info),
> +				    optval,
>   				sizeof(struct tls12_crypto_info_aes_gcm_256)
>   				- sizeof(*crypto_info));
>   
> @@ -565,7 +567,7 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
>   }
>   
>   static int chtls_setsockopt(struct sock *sk, int level, int optname,
> -			    char __user *optval, unsigned int optlen)
> +			    sockptr_t optval, unsigned int optlen)
>   {
>   	struct tls_context *ctx = tls_get_ctx(sk);
>   
> diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
> index 1b2b91479107bc..2835daae9e9f3a 100644
> --- a/drivers/isdn/mISDN/socket.c
> +++ b/drivers/isdn/mISDN/socket.c
> @@ -401,7 +401,7 @@ data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
>   }
>   
>   static int data_sock_setsockopt(struct socket *sock, int level, int optname,
> -				char __user *optval, unsigned int len)
> +				sockptr_t optval, unsigned int len)
>   {
>   	struct sock *sk = sock->sk;
>   	int err = 0, opt = 0;
> @@ -414,7 +414,7 @@ static int data_sock_setsockopt(struct socket *sock, int level, int optname,
>   
>   	switch (optname) {
>   	case MISDN_TIME_STAMP:
> -		if (get_user(opt, (int __user *)optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(int))) {
>   			err = -EFAULT;
>   			break;
>   		}
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 858ff1d981540d..d48ff11808794c 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -21,6 +21,7 @@
>   #include <linux/rcupdate.h>
>   #include <linux/once.h>
>   #include <linux/fs.h>
> +#include <linux/sockptr.h>
>   
>   #include <uapi/linux/net.h>
>   
> @@ -162,7 +163,8 @@ struct proto_ops {
>   	int		(*listen)    (struct socket *sock, int len);
>   	int		(*shutdown)  (struct socket *sock, int flags);
>   	int		(*setsockopt)(struct socket *sock, int level,
> -				      int optname, char __user *optval, unsigned int optlen);
> +				      int optname, sockptr_t optval,
> +				      unsigned int optlen);
>   	int		(*getsockopt)(struct socket *sock, int level,
>   				      int optname, char __user *optval, int __user *optlen);
>   	void		(*show_fdinfo)(struct seq_file *m, struct socket *sock);
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 157c60cca0ca60..1e209ce7d1bd1b 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -16,6 +16,7 @@
>   #include <linux/timer.h>
>   #include <linux/poll.h>
>   #include <linux/kernel.h>
> +#include <linux/sockptr.h>
>   
>   #include <net/inet_sock.h>
>   #include <net/request_sock.h>
> @@ -45,7 +46,7 @@ struct inet_connection_sock_af_ops {
>   	u16	    net_frag_header_len;
>   	u16	    sockaddr_len;
>   	int	    (*setsockopt)(struct sock *sk, int level, int optname,
> -				  char __user *optval, unsigned int optlen);
> +				  sockptr_t optval, unsigned int optlen);
>   	int	    (*getsockopt)(struct sock *sk, int level, int optname,
>   				  char __user *optval, int __user *optlen);
>   	void	    (*addr2sockaddr)(struct sock *sk, struct sockaddr *);
> diff --git a/include/net/ip.h b/include/net/ip.h
> index d66ad3a9522081..b09c48d862cc10 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -722,7 +722,7 @@ void ip_cmsg_recv_offset(struct msghdr *msg, struct sock *sk,
>   			 struct sk_buff *skb, int tlen, int offset);
>   int ip_cmsg_send(struct sock *sk, struct msghdr *msg,
>   		 struct ipcm_cookie *ipc, bool allow_ipv6);
> -int ip_setsockopt(struct sock *sk, int level, int optname, char __user *optval,
> +int ip_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
>   		  unsigned int optlen);
>   int ip_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
>   		  int __user *optlen);
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index 4c9d89b5d73268..bd1f396cc9c729 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1084,8 +1084,8 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
>    *	socket options (ipv6_sockglue.c)
>    */
>   
> -int ipv6_setsockopt(struct sock *sk, int level, int optname,
> -		    char __user *optval, unsigned int optlen);
> +int ipv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> +		    unsigned int optlen);
>   int ipv6_getsockopt(struct sock *sk, int level, int optname,
>   		    char __user *optval, int __user *optlen);
>   
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 233bbf7df5d66c..b33f1aefad0989 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -431,7 +431,7 @@ struct sctp_af {
>   	int		(*setsockopt)	(struct sock *sk,
>   					 int level,
>   					 int optname,
> -					 char __user *optval,
> +					 sockptr_t optval,
>   					 unsigned int optlen);
>   	int		(*getsockopt)	(struct sock *sk,
>   					 int level,
> diff --git a/include/net/sock.h b/include/net/sock.h
> index bfb2fe2fc36876..2cc3ba667908de 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1141,7 +1141,7 @@ struct proto {
>   	void			(*destroy)(struct sock *sk);
>   	void			(*shutdown)(struct sock *sk, int how);
>   	int			(*setsockopt)(struct sock *sk, int level,
> -					int optname, char __user *optval,
> +					int optname, sockptr_t optval,
>   					unsigned int optlen);
>   	int			(*getsockopt)(struct sock *sk, int level,
>   					int optname, char __user *optval,
> @@ -1734,7 +1734,7 @@ int sock_common_getsockopt(struct socket *sock, int level, int optname,
>   int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   			int flags);
>   int sock_common_setsockopt(struct socket *sock, int level, int optname,
> -				  char __user *optval, unsigned int optlen);
> +			   sockptr_t optval, unsigned int optlen);
>   
>   void sk_common_release(struct sock *sk);
>   
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index e3c8e1d820214c..e0c35d56091f22 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -399,8 +399,8 @@ __poll_t tcp_poll(struct file *file, struct socket *sock,
>   		      struct poll_table_struct *wait);
>   int tcp_getsockopt(struct sock *sk, int level, int optname,
>   		   char __user *optval, int __user *optlen);
> -int tcp_setsockopt(struct sock *sk, int level, int optname,
> -		   char __user *optval, unsigned int optlen);
> +int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> +		   unsigned int optlen);
>   void tcp_set_keepalive(struct sock *sk, int val);
>   void tcp_syn_ack_timeout(const struct request_sock *req);
>   int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
> diff --git a/net/atm/common.c b/net/atm/common.c
> index 9b28f1fb3c69c8..84367b844b1473 100644
> --- a/net/atm/common.c
> +++ b/net/atm/common.c
> @@ -745,7 +745,7 @@ static int check_qos(const struct atm_qos *qos)
>   }
>   
>   int vcc_setsockopt(struct socket *sock, int level, int optname,
> -		   char __user *optval, unsigned int optlen)
> +		   sockptr_t optval, unsigned int optlen)
>   {
>   	struct atm_vcc *vcc;
>   	unsigned long value;
> @@ -760,7 +760,7 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
>   	{
>   		struct atm_qos qos;
>   
> -		if (copy_from_user(&qos, optval, sizeof(qos)))
> +		if (copy_from_sockptr(&qos, optval, sizeof(qos)))
>   			return -EFAULT;
>   		error = check_qos(&qos);
>   		if (error)
> @@ -774,7 +774,7 @@ int vcc_setsockopt(struct socket *sock, int level, int optname,
>   		return 0;
>   	}
>   	case SO_SETCLP:
> -		if (get_user(value, (unsigned long __user *)optval))
> +		if (copy_from_sockptr(&value, optval, sizeof(value)))
>   			return -EFAULT;
>   		if (value)
>   			vcc->atm_options |= ATM_ATMOPT_CLP;
> diff --git a/net/atm/common.h b/net/atm/common.h
> index 5850649068bb29..a1e56e8de698a3 100644
> --- a/net/atm/common.h
> +++ b/net/atm/common.h
> @@ -21,7 +21,7 @@ __poll_t vcc_poll(struct file *file, struct socket *sock, poll_table *wait);
>   int vcc_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
>   int vcc_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
>   int vcc_setsockopt(struct socket *sock, int level, int optname,
> -		   char __user *optval, unsigned int optlen);
> +		   sockptr_t optval, unsigned int optlen);
>   int vcc_getsockopt(struct socket *sock, int level, int optname,
>   		   char __user *optval, int __user *optlen);
>   void vcc_process_recv_queue(struct atm_vcc *vcc);
> diff --git a/net/atm/pvc.c b/net/atm/pvc.c
> index 02bd2a436bdf9e..53e7d3f39e26cc 100644
> --- a/net/atm/pvc.c
> +++ b/net/atm/pvc.c
> @@ -63,7 +63,7 @@ static int pvc_connect(struct socket *sock, struct sockaddr *sockaddr,
>   }
>   
>   static int pvc_setsockopt(struct socket *sock, int level, int optname,
> -			  char __user *optval, unsigned int optlen)
> +			  sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	int error;
> diff --git a/net/atm/svc.c b/net/atm/svc.c
> index ba144d035e3d41..4a02bcaad279f8 100644
> --- a/net/atm/svc.c
> +++ b/net/atm/svc.c
> @@ -451,7 +451,7 @@ int svc_change_qos(struct atm_vcc *vcc, struct atm_qos *qos)
>   }
>   
>   static int svc_setsockopt(struct socket *sock, int level, int optname,
> -			  char __user *optval, unsigned int optlen)
> +			  sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct atm_vcc *vcc = ATM_SD(sock);
> @@ -464,7 +464,7 @@ static int svc_setsockopt(struct socket *sock, int level, int optname,
>   			error = -EINVAL;
>   			goto out;
>   		}
> -		if (copy_from_user(&vcc->sap, optval, optlen)) {
> +		if (copy_from_sockptr(&vcc->sap, optval, optlen)) {
>   			error = -EFAULT;
>   			goto out;
>   		}
> @@ -475,7 +475,7 @@ static int svc_setsockopt(struct socket *sock, int level, int optname,
>   			error = -EINVAL;
>   			goto out;
>   		}
> -		if (get_user(value, (int __user *)optval)) {
> +		if (copy_from_sockptr(&value, optval, sizeof(int))) {
>   			error = -EFAULT;
>   			goto out;
>   		}
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index fd91cd34f25e03..17bf31a8969284 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -528,7 +528,7 @@ ax25_cb *ax25_create_cb(void)
>    */
>   
>   static int ax25_setsockopt(struct socket *sock, int level, int optname,
> -	char __user *optval, unsigned int optlen)
> +		sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	ax25_cb *ax25;
> @@ -543,7 +543,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
>   	if (optlen < sizeof(unsigned int))
>   		return -EINVAL;
>   
> -	if (get_user(opt, (unsigned int __user *)optval))
> +	if (copy_from_sockptr(&opt, optval, sizeof(unsigned int)))
>   		return -EFAULT;
>   
>   	lock_sock(sk);
> @@ -640,7 +640,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
>   
>   		memset(devname, 0, sizeof(devname));
>   
> -		if (copy_from_user(devname, optval, optlen)) {
> +		if (copy_from_sockptr(devname, optval, optlen)) {
>   			res = -EFAULT;
>   			break;
>   		}
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index caf38a8ea6a8ba..d5eff27d5b1e17 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -1842,7 +1842,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>   }
>   
>   static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
> -			       char __user *optval, unsigned int len)
> +			       sockptr_t optval, unsigned int len)
>   {
>   	struct hci_ufilter uf = { .opcode = 0 };
>   	struct sock *sk = sock->sk;
> @@ -1862,7 +1862,7 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
>   
>   	switch (optname) {
>   	case HCI_DATA_DIR:
> -		if (get_user(opt, (int __user *)optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(opt))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -1874,7 +1874,7 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
>   		break;
>   
>   	case HCI_TIME_STAMP:
> -		if (get_user(opt, (int __user *)optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(opt))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -1896,7 +1896,7 @@ static int hci_sock_setsockopt(struct socket *sock, int level, int optname,
>   		}
>   
>   		len = min_t(unsigned int, len, sizeof(uf));
> -		if (copy_from_user(&uf, optval, len)) {
> +		if (copy_from_sockptr(&uf, optval, len)) {
>   			err = -EFAULT;
>   			break;
>   		}
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index a995d2c51fa7f1..a3d104123f38dd 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -703,7 +703,7 @@ static bool l2cap_valid_mtu(struct l2cap_chan *chan, u16 mtu)
>   }
>   
>   static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
> -				     char __user *optval, unsigned int optlen)
> +				     sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
> @@ -736,7 +736,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
>   		opts.txwin_size = chan->tx_win;
>   
>   		len = min_t(unsigned int, sizeof(opts), optlen);
> -		if (copy_from_user((char *) &opts, optval, len)) {
> +		if (copy_from_sockptr(&opts, optval, len)) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -782,7 +782,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
>   		break;
>   
>   	case L2CAP_LM:
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -859,7 +859,7 @@ static int l2cap_set_mode(struct l2cap_chan *chan, u8 mode)
>   }
>   
>   static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
> -				 char __user *optval, unsigned int optlen)
> +				 sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
> @@ -891,7 +891,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   		sec.level = BT_SECURITY_LOW;
>   
>   		len = min_t(unsigned int, sizeof(sec), optlen);
> -		if (copy_from_user((char *) &sec, optval, len)) {
> +		if (copy_from_sockptr(&sec, optval, len)) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -939,7 +939,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   			break;
>   		}
>   
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -954,7 +954,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   		break;
>   
>   	case BT_FLUSHABLE:
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -990,7 +990,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   		pwr.force_active = BT_POWER_FORCE_ACTIVE_ON;
>   
>   		len = min_t(unsigned int, sizeof(pwr), optlen);
> -		if (copy_from_user((char *) &pwr, optval, len)) {
> +		if (copy_from_sockptr(&pwr, optval, len)) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -1002,7 +1002,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   		break;
>   
>   	case BT_CHANNEL_POLICY:
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -1050,7 +1050,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   			break;
>   		}
>   
> -		if (get_user(opt, (u16 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u16))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -1081,7 +1081,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
>   			break;
>   		}
>   
> -		if (get_user(opt, (u8 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u8))) {
>   			err = -EFAULT;
>   			break;
>   		}
> diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
> index df14eebe80da8b..dba4ea0e1b0dc7 100644
> --- a/net/bluetooth/rfcomm/sock.c
> +++ b/net/bluetooth/rfcomm/sock.c
> @@ -644,7 +644,8 @@ static int rfcomm_sock_recvmsg(struct socket *sock, struct msghdr *msg,
>   	return len;
>   }
>   
> -static int rfcomm_sock_setsockopt_old(struct socket *sock, int optname, char __user *optval, unsigned int optlen)
> +static int rfcomm_sock_setsockopt_old(struct socket *sock, int optname,
> +		sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	int err = 0;
> @@ -656,7 +657,7 @@ static int rfcomm_sock_setsockopt_old(struct socket *sock, int optname, char __u
>   
>   	switch (optname) {
>   	case RFCOMM_LM:
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -685,7 +686,8 @@ static int rfcomm_sock_setsockopt_old(struct socket *sock, int optname, char __u
>   	return err;
>   }
>   
> -static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
> +static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname,
> +		sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct bt_security sec;
> @@ -713,7 +715,7 @@ static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname, c
>   		sec.level = BT_SECURITY_LOW;
>   
>   		len = min_t(unsigned int, sizeof(sec), optlen);
> -		if (copy_from_user((char *) &sec, optval, len)) {
> +		if (copy_from_sockptr(&sec, optval, len)) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -732,7 +734,7 @@ static int rfcomm_sock_setsockopt(struct socket *sock, int level, int optname, c
>   			break;
>   		}
>   
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index c8c3d38cdc7b56..37260baf71507b 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -791,7 +791,7 @@ static int sco_sock_recvmsg(struct socket *sock, struct msghdr *msg,
>   }
>   
>   static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
> -			       char __user *optval, unsigned int optlen)
> +			       sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	int len, err = 0;
> @@ -810,7 +810,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
>   			break;
>   		}
>   
> -		if (get_user(opt, (u32 __user *) optval)) {
> +		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
>   			err = -EFAULT;
>   			break;
>   		}
> @@ -831,7 +831,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
>   		voice.setting = sco_pi(sk)->setting;
>   
>   		len = min_t(unsigned int, sizeof(voice), optlen);
> -		if (copy_from_user((char *)&voice, optval, len)) {
> +		if (copy_from_sockptr(&voice, optval, len)) {
>   			err = -EFAULT;
>   			break;
>   		}
> diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
> index b94ecd931002e7..3ad0a1df671283 100644
> --- a/net/caif/caif_socket.c
> +++ b/net/caif/caif_socket.c
> @@ -669,8 +669,8 @@ static int caif_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>   	return sent ? : err;
>   }
>   
> -static int setsockopt(struct socket *sock,
> -		      int lvl, int opt, char __user *ov, unsigned int ol)
> +static int setsockopt(struct socket *sock, int lvl, int opt, sockptr_t ov,
> +		unsigned int ol)
>   {
>   	struct sock *sk = sock->sk;
>   	struct caifsock *cf_sk = container_of(sk, struct caifsock, sk);
> @@ -685,7 +685,7 @@ static int setsockopt(struct socket *sock,
>   			return -EINVAL;
>   		if (lvl != SOL_CAIF)
>   			goto bad_sol;
> -		if (copy_from_user(&linksel, ov, sizeof(int)))
> +		if (copy_from_sockptr(&linksel, ov, sizeof(int)))
>   			return -EINVAL;
>   		lock_sock(&(cf_sk->sk));
>   		cf_sk->conn_req.link_selector = linksel;
> @@ -699,7 +699,7 @@ static int setsockopt(struct socket *sock,
>   			return -ENOPROTOOPT;
>   		lock_sock(&(cf_sk->sk));
>   		if (ol > sizeof(cf_sk->conn_req.param.data) ||
> -			copy_from_user(&cf_sk->conn_req.param.data, ov, ol)) {
> +		    copy_from_sockptr(&cf_sk->conn_req.param.data, ov, ol)) {
>   			release_sock(&cf_sk->sk);
>   			return -EINVAL;
>   		}
> diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> index f7587428febdd2..78ff9b3f1d40c7 100644
> --- a/net/can/j1939/socket.c
> +++ b/net/can/j1939/socket.c
> @@ -627,14 +627,14 @@ static int j1939_sk_release(struct socket *sock)
>   	return 0;
>   }
>   
> -static int j1939_sk_setsockopt_flag(struct j1939_sock *jsk, char __user *optval,
> +static int j1939_sk_setsockopt_flag(struct j1939_sock *jsk, sockptr_t optval,
>   				    unsigned int optlen, int flag)
>   {
>   	int tmp;
>   
>   	if (optlen != sizeof(tmp))
>   		return -EINVAL;
> -	if (copy_from_user(&tmp, optval, optlen))
> +	if (copy_from_sockptr(&tmp, optval, optlen))
>   		return -EFAULT;
>   	lock_sock(&jsk->sk);
>   	if (tmp)
> @@ -646,7 +646,7 @@ static int j1939_sk_setsockopt_flag(struct j1939_sock *jsk, char __user *optval,
>   }
>   
>   static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
> -			       char __user *optval, unsigned int optlen)
> +			       sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct j1939_sock *jsk = j1939_sk(sk);
> @@ -658,7 +658,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
>   
>   	switch (optname) {
>   	case SO_J1939_FILTER:
> -		if (optval) {
> +		if (!sockptr_is_null(optval)) {
>   			struct j1939_filter *f;
>   			int c;
>   
> @@ -670,7 +670,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
>   				return -EINVAL;
>   
>   			count = optlen / sizeof(*filters);
> -			filters = memdup_user(optval, optlen);
> +			filters = memdup_sockptr(optval, optlen);
>   			if (IS_ERR(filters))
>   				return PTR_ERR(filters);
>   
> @@ -703,7 +703,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
>   	case SO_J1939_SEND_PRIO:
>   		if (optlen != sizeof(tmp))
>   			return -EINVAL;
> -		if (copy_from_user(&tmp, optval, optlen))
> +		if (copy_from_sockptr(&tmp, optval, optlen))
>   			return -EFAULT;
>   		if (tmp < 0 || tmp > 7)
>   			return -EDOM;
> diff --git a/net/can/raw.c b/net/can/raw.c
> index 59c039d73c6d58..94a9405658dc61 100644
> --- a/net/can/raw.c
> +++ b/net/can/raw.c
> @@ -485,7 +485,7 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
>   }
>   
>   static int raw_setsockopt(struct socket *sock, int level, int optname,
> -			  char __user *optval, unsigned int optlen)
> +			  sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	struct raw_sock *ro = raw_sk(sk);
> @@ -511,11 +511,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   
>   		if (count > 1) {
>   			/* filter does not fit into dfilter => alloc space */
> -			filter = memdup_user(optval, optlen);
> +			filter = memdup_sockptr(optval, optlen);
>   			if (IS_ERR(filter))
>   				return PTR_ERR(filter);
>   		} else if (count == 1) {
> -			if (copy_from_user(&sfilter, optval, sizeof(sfilter)))
> +			if (copy_from_sockptr(&sfilter, optval, sizeof(sfilter)))
>   				return -EFAULT;
>   		}
>   
> @@ -568,7 +568,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   		if (optlen != sizeof(err_mask))
>   			return -EINVAL;
>   
> -		if (copy_from_user(&err_mask, optval, optlen))
> +		if (copy_from_sockptr(&err_mask, optval, optlen))
>   			return -EFAULT;
>   
>   		err_mask &= CAN_ERR_MASK;
> @@ -607,7 +607,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   		if (optlen != sizeof(ro->loopback))
>   			return -EINVAL;
>   
> -		if (copy_from_user(&ro->loopback, optval, optlen))
> +		if (copy_from_sockptr(&ro->loopback, optval, optlen))
>   			return -EFAULT;
>   
>   		break;
> @@ -616,7 +616,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   		if (optlen != sizeof(ro->recv_own_msgs))
>   			return -EINVAL;
>   
> -		if (copy_from_user(&ro->recv_own_msgs, optval, optlen))
> +		if (copy_from_sockptr(&ro->recv_own_msgs, optval, optlen))
>   			return -EFAULT;
>   
>   		break;
> @@ -625,7 +625,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   		if (optlen != sizeof(ro->fd_frames))
>   			return -EINVAL;
>   
> -		if (copy_from_user(&ro->fd_frames, optval, optlen))
> +		if (copy_from_sockptr(&ro->fd_frames, optval, optlen))
>   			return -EFAULT;
>   
>   		break;
> @@ -634,7 +634,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>   		if (optlen != sizeof(ro->join_filters))
>   			return -EINVAL;
>   
> -		if (copy_from_user(&ro->join_filters, optval, optlen))
> +		if (copy_from_sockptr(&ro->join_filters, optval, optlen))
>   			return -EFAULT;
>   
>   		break;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 9cf8318bc51de4..ff22629f10ce92 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3210,7 +3210,7 @@ EXPORT_SYMBOL(sock_common_recvmsg);
>    *	Set socket options on an inet socket.
>    */
>   int sock_common_setsockopt(struct socket *sock, int level, int optname,
> -			   char __user *optval, unsigned int optlen)
> +			   sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   
> diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
> index 434eea91b7679d..9cc9d1ee6cdb9a 100644
> --- a/net/dccp/dccp.h
> +++ b/net/dccp/dccp.h
> @@ -295,7 +295,7 @@ int dccp_disconnect(struct sock *sk, int flags);
>   int dccp_getsockopt(struct sock *sk, int level, int optname,
>   		    char __user *optval, int __user *optlen);
>   int dccp_setsockopt(struct sock *sk, int level, int optname,
> -		    char __user *optval, unsigned int optlen);
> +		    sockptr_t optval, unsigned int optlen);
>   int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg);
>   int dccp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
>   int dccp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index fd92d3fe321f08..9e58787047f197 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -402,7 +402,7 @@ int dccp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>   EXPORT_SYMBOL_GPL(dccp_ioctl);
>   
>   static int dccp_setsockopt_service(struct sock *sk, const __be32 service,
> -				   char __user *optval, unsigned int optlen)
> +				   sockptr_t optval, unsigned int optlen)
>   {
>   	struct dccp_sock *dp = dccp_sk(sk);
>   	struct dccp_service_list *sl = NULL;
> @@ -417,9 +417,9 @@ static int dccp_setsockopt_service(struct sock *sk, const __be32 service,
>   			return -ENOMEM;
>   
>   		sl->dccpsl_nr = optlen / sizeof(u32) - 1;
> -		if (copy_from_user(sl->dccpsl_list,
> -				   optval + sizeof(service),
> -				   optlen - sizeof(service)) ||
> +		sockptr_advance(optval, sizeof(service));
> +		if (copy_from_sockptr(sl->dccpsl_list, optval,
> +				      optlen - sizeof(service)) ||
>   		    dccp_list_has_service(sl, DCCP_SERVICE_INVALID_VALUE)) {
>   			kfree(sl);
>   			return -EFAULT;
> @@ -473,7 +473,7 @@ static int dccp_setsockopt_cscov(struct sock *sk, int cscov, bool rx)
>   }
>   
>   static int dccp_setsockopt_ccid(struct sock *sk, int type,
> -				char __user *optval, unsigned int optlen)
> +				sockptr_t optval, unsigned int optlen)
>   {
>   	u8 *val;
>   	int rc = 0;
> @@ -481,7 +481,7 @@ static int dccp_setsockopt_ccid(struct sock *sk, int type,
>   	if (optlen < 1 || optlen > DCCP_FEAT_MAX_SP_VALS)
>   		return -EINVAL;
>   
> -	val = memdup_user(optval, optlen);
> +	val = memdup_sockptr(optval, optlen);
>   	if (IS_ERR(val))
>   		return PTR_ERR(val);
>   
> @@ -498,7 +498,7 @@ static int dccp_setsockopt_ccid(struct sock *sk, int type,
>   }
>   
>   static int do_dccp_setsockopt(struct sock *sk, int level, int optname,
> -		char __user *optval, unsigned int optlen)
> +		sockptr_t optval, unsigned int optlen)
>   {
>   	struct dccp_sock *dp = dccp_sk(sk);
>   	int val, err = 0;
> @@ -520,7 +520,7 @@ static int do_dccp_setsockopt(struct sock *sk, int level, int optname,
>   	if (optlen < (int)sizeof(int))
>   		return -EINVAL;
>   
> -	if (get_user(val, (int __user *)optval))
> +	if (copy_from_sockptr(&val, optval, sizeof(int)))
>   		return -EFAULT;
>   
>   	if (optname == DCCP_SOCKOPT_SERVICE)
> @@ -563,8 +563,8 @@ static int do_dccp_setsockopt(struct sock *sk, int level, int optname,
>   	return err;
>   }
>   
> -int dccp_setsockopt(struct sock *sk, int level, int optname,
> -		    char __user *optval, unsigned int optlen)
> +int dccp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> +		    unsigned int optlen)
>   {
>   	if (level != SOL_DCCP)
>   		return inet_csk(sk)->icsk_af_ops->setsockopt(sk, level,
> diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
> index 7d51ab608fb3f1..3b53d766789d47 100644
> --- a/net/decnet/af_decnet.c
> +++ b/net/decnet/af_decnet.c
> @@ -150,7 +150,8 @@ static struct hlist_head dn_sk_hash[DN_SK_HASH_SIZE];
>   static struct hlist_head dn_wild_sk;
>   static atomic_long_t decnet_memory_allocated;
>   
> -static int __dn_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen, int flags);
> +static int __dn_setsockopt(struct socket *sock, int level, int optname,
> +		sockptr_t optval, unsigned int optlen, int flags);
>   static int __dn_getsockopt(struct socket *sock, int level, int optname, char __user *optval, int __user *optlen, int flags);
>   
>   static struct hlist_head *dn_find_list(struct sock *sk)
> @@ -1320,7 +1321,8 @@ static int dn_shutdown(struct socket *sock, int how)
>   	return err;
>   }
>   
> -static int dn_setsockopt(struct socket *sock, int level, int optname, char __user *optval, unsigned int optlen)
> +static int dn_setsockopt(struct socket *sock, int level, int optname,
> +		sockptr_t optval, unsigned int optlen)
>   {
>   	struct sock *sk = sock->sk;
>   	int err;
> @@ -1332,14 +1334,14 @@ static int dn_setsockopt(struct socket *sock, int level, int optname, char __use
>   	/* we need to exclude all possible ENOPROTOOPTs except default case */
>   	if (err == -ENOPROTOOPT && optname != DSO_LINKINFO &&
>   	    optname != DSO_STREAM && optname != DSO_SEQPACKET)
> -		err = nf_setsockopt(sk, PF_DECnet, optname,
> -				    USER_SOCKPTR(optval), optlen);
> +		err = nf_setsockopt(sk, PF_DECnet, optname, optval, optlen);
>   #endif
>   
>   	return err;
>   }
>   
> -static int __dn_setsockopt(struct socket *sock, int level,int optname, char __user *optval, unsigned int optlen, int flags)
> +static int __dn_setsockopt(struct socket *sock, int level, int optname,
> +		sockptr_t optval, unsigned int optlen, int flags)
>   {
>   	struct	sock *sk = sock->sk;
>   	struct dn_scp *scp = DN_SK(sk);
> @@ -1355,13 +1357,13 @@ static int __dn_setsockopt(struct socket *sock, int level,int optname, char __us
>   	} u;
>   	int err;
>   
> -	if (optlen && !optval)
> +	if (optlen && sockptr_is_null(optval))
>   		return -EINVAL;
>   
>   	if (optlen > sizeof(u))
>   		return -EINVAL;
>   
> -	if (copy_from_user(&u, optval, optlen))
> +	if (copy_from_sockptr(&u, optval, optlen))
>   		return -EFAULT;
>   
>   	switch (optname) {
> diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
> index 94ae9662133e30..a45a0401adc50b 100644
> --- a/net/ieee802154/socket.c
> +++ b/net/ieee802154/socket.c
> @@ -382,7 +382,7 @@ static int raw_getsockopt(struct sock *sk, int level, int optname,
>   }
>   
>   static int raw_setsockopt(struct sock *sk, int level, int optname,
> -			  char __user *optval, unsigned int optlen)
> +			  sockptr_t optval, unsigned int optlen)
>   {
>   	return -EOPNOTSUPP;
>   }
> @@ -872,7 +872,7 @@ static int dgram_getsockopt(struct sock *sk, int level, int optname,
>   }
>   
>   static int dgram_setsockopt(struct sock *sk, int level, int optname,
> -			    char __user *optval, unsigned int optlen)
> +			    sockptr_t optval, unsigned int optlen)
>   {
>   	struct dgram_sock *ro = dgram_sk(sk);
>   	struct net *net = sock_net(sk);
> @@ -882,7 +882,7 @@ static int dgram_setsockopt(struct sock *sk, int level, int optname,
>   	if (optlen < sizeof(int))
>   		return -EINVAL;
>   
> -	if (get_user(val, (int __user *)optval))
> +	if (copy_from_sockptr(&val, optval, sizeof(int)))
>   		return -EFAULT;
>   

For the ieee802154 part:

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
