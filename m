Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FD368F60A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjBHRtT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Feb 2023 12:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjBHRtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:49:16 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8520A26CD9
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 09:48:48 -0800 (PST)
Received: from smtpclient.apple (p5b3d2eb0.dip0.t-ipconnect.de [91.61.46.176])
        by mail.holtmann.org (Postfix) with ESMTPSA id C489BCED26;
        Wed,  8 Feb 2023 18:48:17 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: [PATCH v3 2/2] net/tls: Support AF_HANDSHAKE in kTLS
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <e7042e3d-19c1-2137-5f43-979a6ee090d7@suse.de>
Date:   Wed, 8 Feb 2023 18:48:17 +0100
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, hare@suse.com,
        dhowells@redhat.com, bcodding@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <1A217F34-D293-4743-A33C-65BF34614E36@holtmann.org>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580608014.5328.8882324552456238932.stgit@91.116.238.104.host.secureserver.net>
 <e7042e3d-19c1-2137-5f43-979a6ee090d7@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-Spam-Status: No, score=1.6 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_00,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hannes,

>> To enable kernel consumers of TLS to request a TLS handshake, add
>> support to net/tls/ to send a handshake upcall.
>> This patch also acts as a template for adding handshake upcall
>> support to other transport layer security mechanisms.
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>>  include/net/tls.h              |   16 +
>>  include/uapi/linux/handshake.h |   30 ++
>>  net/tls/Makefile               |    2
>>  net/tls/tls_handshake.c        |  583 ++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 630 insertions(+), 1 deletion(-)
>>  create mode 100644 net/tls/tls_handshake.c
>> diff --git a/include/net/tls.h b/include/net/tls.h
>> index 154949c7b0c8..5156c3a80faa 100644
>> --- a/include/net/tls.h
>> +++ b/include/net/tls.h
>> @@ -512,4 +512,20 @@ static inline bool tls_is_sk_rx_device_offloaded(struct sock *sk)
>>  	return tls_get_ctx(sk)->rx_conf == TLS_HW;
>>  }
>>  #endif
>> +
>> +#define TLS_DEFAULT_PRIORITIES		(NULL)
>> +
>> +int tls_client_hello_anon(struct socket *sock,
>> +			  void (*done)(void *data, int status), void *data,
>> +			  const char *priorities);
>> +int tls_client_hello_x509(struct socket *sock,
>> +			  void (*done)(void *data, int status), void *data,
>> +			  const char *priorities, key_serial_t cert,
>> +			  key_serial_t privkey);
>> +int tls_client_hello_psk(struct socket *sock,
>> +			 void (*done)(void *data, int status), void *data,
>> +			 const char *priorities, key_serial_t peerid);
>> +int tls_server_hello(struct socket *sock, void (*done)(void *data, int status),
>> +		     void *data, const char *priorities);
>> +
>>  #endif /* _TLS_OFFLOAD_H */
>> diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handshake.h
>> index 39cab687eece..54d926a49ee0 100644
>> --- a/include/uapi/linux/handshake.h
>> +++ b/include/uapi/linux/handshake.h
>> @@ -19,6 +19,7 @@
>>  /* Multicast Netlink socket groups */
>>  enum handshake_nlgrps {
>>  	HANDSHAKE_NLGRP_NONE = 0,
>> +	HANDSHAKE_NLGRP_TLS_13,
>>  	__HANDSHAKE_NLGRP_MAX
>>  };
>>  #define HSNLGRP_MAX	(__HANDSHAKE_NLGRP_MAX - 1)
>> @@ -40,6 +41,15 @@ enum handshake_nl_attrs {
>>  	HANDSHAKE_NL_ATTR_ACCEPT_RESP,
>>  	HANDSHAKE_NL_ATTR_DONE_ARGS,
>>  +	HANDSHAKE_NL_ATTR_TLS_TYPE = 20,
>> +	HANDSHAKE_NL_ATTR_TLS_AUTH,
>> +	HANDSHAKE_NL_ATTR_TLS_PRIORITIES,
>> +	HANDSHAKE_NL_ATTR_TLS_X509_CERT,
>> +	HANDSHAKE_NL_ATTR_TLS_X509_PRIVKEY,
>> +	HANDSHAKE_NL_ATTR_TLS_PSK,
>> +	HANDSHAKE_NL_ATTR_TLS_SESS_STATUS,
>> +	HANDSHAKE_NL_ATTR_TLS_PEERID,
>> +
>>  	__HANDSHAKE_NL_ATTR_MAX
>>  };
>>  #define HANDSHAKE_NL_ATTR_MAX	(__HANDSHAKE_NL_ATTR_MAX - 1)
>> @@ -54,6 +64,26 @@ enum handshake_nl_status {
>>    enum handshake_nl_protocol {
>>  	HANDSHAKE_NL_PROTO_UNSPEC = 0,
>> +	HANDSHAKE_NL_PROTO_TLS_13,
>> +};
>> +
>> +enum handshake_nl_tls_type {
>> +	HANDSHAKE_NL_TLS_TYPE_UNSPEC = 0,
>> +	HANDSHAKE_NL_TLS_TYPE_CLIENTHELLO,
>> +	HANDSHAKE_NL_TLS_TYPE_SERVERHELLO,
>> +};
>> +
>> +enum handshake_nl_tls_auth {
>> +	HANDSHAKE_NL_TLS_AUTH_UNSPEC = 0,
>> +	HANDSHAKE_NL_TLS_AUTH_UNAUTH,
>> +	HANDSHAKE_NL_TLS_AUTH_X509,
>> +	HANDSHAKE_NL_TLS_AUTH_PSK,
>> +};
>> +
>> +enum {
>> +	HANDSHAKE_NO_PEERID = 0,
>> +	HANDSHAKE_NO_CERT = 0,
>> +	HANDSHAKE_NO_PRIVKEY = 0,
>>  };
>>    enum handshake_nl_tls_session_status {
>> diff --git a/net/tls/Makefile b/net/tls/Makefile
>> index e41c800489ac..7e56b57f14f6 100644
>> --- a/net/tls/Makefile
>> +++ b/net/tls/Makefile
>> @@ -7,7 +7,7 @@ CFLAGS_trace.o := -I$(src)
>>    obj-$(CONFIG_TLS) += tls.o
>>  -tls-y := tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
>> +tls-y := tls_handshake.o tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
>>    tls-$(CONFIG_TLS_TOE) += tls_toe.o
>>  tls-$(CONFIG_TLS_DEVICE) += tls_device.o tls_device_fallback.o
>> diff --git a/net/tls/tls_handshake.c b/net/tls/tls_handshake.c
>> new file mode 100644
>> index 000000000000..18fcea1513b0
>> --- /dev/null
>> +++ b/net/tls/tls_handshake.c
>> @@ -0,0 +1,583 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Establish a TLS session for a kernel socket consumer
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2021-2023, Oracle and/or its affiliates.
>> + */
>> +
>> +/**
>> + * DOC: kTLS handshake overview
>> + *
>> + * When a kernel TLS consumer wants to establish a TLS session, it
>> + * makes an AF_TLSH Listener ready. When user space accepts on that
>> + * listener, the kernel fabricates a user space socket endpoint on
>> + * which a user space TLS library can perform the TLS handshake.
>> + *
>> + * Closing the user space descriptor signals to the kernel that the
>> + * library handshake process is complete. If the library has managed
>> + * to initialize the socket's TLS crypto_info, the kernel marks the
>> + * handshake as a success.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/socket.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +
>> +#include <net/sock.h>
>> +#include <net/tls.h>
>> +#include <net/handshake.h>
>> +
>> +#include <uapi/linux/handshake.h>
>> +
>> +static void tlsh_handshake_done(struct handshake_info *hsi,
>> +				struct sk_buff *skb, struct nlmsghdr *nlh,
>> +				struct nlattr *tb);
>> +
>> +struct tlsh_sock_info {
>> +	struct handshake_info	tsi_handshake_info;
>> +
>> +	void			(*tsi_handshake_done)(void *data, int status);
>> +	void			*tsi_handshake_data;
>> +
>> +	char			*tsi_tls_priorities;
>> +	key_serial_t		tsi_peerid;
>> +	key_serial_t		tsi_certificate;
>> +	key_serial_t		tsi_privkey;
>> +
>> +};
>> +
>> +static struct tlsh_sock_info *
>> +tlsh_sock_info_alloc(struct socket *sock, void (*done)(void *data, int status),
>> +		     void *data, const char *priorities)
>> +{
>> +	struct tlsh_sock_info *tsi;
>> +
>> +	tsi = kzalloc(sizeof(*tsi), GFP_KERNEL);
>> +	if (!tsi)
>> +		return NULL;
>> +
>> +	if (priorities != TLS_DEFAULT_PRIORITIES && strlen(priorities)) {
>> +		tsi->tsi_tls_priorities = kstrdup(priorities, GFP_KERNEL);
>> +		if (!tsi->tsi_tls_priorities) {
>> +			kfree(tsi);
>> +			return NULL;
>> +		}
>> +	}
>> +
>> +	sock_hold(sock->sk);
>> +	tsi->tsi_handshake_info.hi_done = tlsh_handshake_done,
>> +	tsi->tsi_handshake_info.hi_sock = sock;
>> +	tsi->tsi_handshake_info.hi_mcgrp = HANDSHAKE_NLGRP_TLS_13;
>> +	tsi->tsi_handshake_info.hi_protocol = HANDSHAKE_NL_PROTO_TLS_13;
>> +
>> +	tsi->tsi_handshake_done = done;
>> +	tsi->tsi_handshake_data = data;
>> +	tsi->tsi_peerid = HANDSHAKE_NO_PEERID;
>> +	tsi->tsi_certificate = HANDSHAKE_NO_CERT;
>> +	tsi->tsi_privkey = HANDSHAKE_NO_PRIVKEY;
>> +
>> +	return tsi;
>> +}
>> +
>> +static void tlsh_sock_info_free(struct tlsh_sock_info *tsi)
>> +{
>> +	if (!tsi)
>> +		return;
>> +
>> +	if (tsi->tsi_handshake_info.hi_sock)
>> +		__sock_put(tsi->tsi_handshake_info.hi_sock->sk);
>> +	kfree(tsi->tsi_tls_priorities);
>> +	kfree(tsi);
>> +}
>> +
>> +static const struct nla_policy
>> +handshake_nl_attr_tls_policy[HANDSHAKE_NL_ATTR_MAX + 1] = {
>> +	[HANDSHAKE_NL_ATTR_TLS_TYPE] = {
>> +		.type = NLA_U32
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_AUTH] = {
>> +		.type = NLA_U32
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_PRIORITIES] = {
>> +		.type = NLA_STRING
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_X509_CERT] = {
>> +		.type = NLA_U32
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_X509_PRIVKEY] = {
>> +		.type = NLA_U32
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_PSK] = {
>> +		.type = NLA_U32
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_SESS_STATUS] = {
>> +		.type = NLA_U32,
>> +	},
>> +	[HANDSHAKE_NL_ATTR_TLS_PEERID] = {
>> +		.type = NLA_U32,
>> +	},
>> +};
>> +
>> +/**
>> + * tlsh_handshake_done - call the handshake "done" callback for @sk.
>> + * @hsi: socket on which the handshake was performed
>> + * @skb: buffer containing incoming DONE msg
>> + * @nlh: pointer to netlink message header
>> + * @args: nested attributes for the TLS subsystem
>> + *
>> + * Eventually this will return information about the established
>> + * session: whether it is authenticated, and if so, who the remote
>> + * is.
>> + */
>> +static void tlsh_handshake_done(struct handshake_info *hsi,
>> +				struct sk_buff *skb, struct nlmsghdr *nlh,
>> +				struct nlattr *args)
>> +{
>> +	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
>> +						  tsi_handshake_info);
>> +	void (*done)(void *data, int status) = tsi->tsi_handshake_done;
>> +	struct nlattr *tb[HANDSHAKE_NL_ATTR_MAX + 1];
>> +	int err, status;
>> +
>> +	status = -EIO;
>> +	err = nla_parse_nested(tb, HANDSHAKE_NL_ATTR_MAX, args,
>> +			       handshake_nl_attr_tls_policy, NULL);
>> +	if (err < 0)
>> +		goto out;
>> +
>> +	if (!tb[HANDSHAKE_NL_ATTR_TLS_SESS_STATUS])
>> +		goto out;
>> +
> For server hello we need to include the selected key here; there's a chance the caller requires the key to be used for further processing.
> 
>> +	switch (nla_get_u32(tb[HANDSHAKE_NL_ATTR_TLS_SESS_STATUS])) {
>> +	case HANDSHAKE_NL_TLS_SESS_STATUS_OK:
>> +		status = 0;
>> +		break;
>> +	case HANDSHAKE_NL_TLS_SESS_STATUS_REJECTED:
>> +		status = -EACCES;
>> +		break;
>> +	default:
>> +		status = -EIO;
>> +	}
>> +
>> +out:
>> +	done(tsi->tsi_handshake_data, status);
>> +	tlsh_sock_info_free(tsi);
>> +}
>> + > +/*
>> + * Specifically for kernel TLS consumers: enable only TLS v1.3 and the
>> + * ciphers that are supported by kTLS.
>> + *
>> + * This list is generated by hand from the supported ciphers found
>> + * in include/uapi/linux/tls.h.
>> + */
>> +#define KTLS_PRIORITIES \
>> +	"SECURE256:+SECURE128:-COMP-ALL" \
>> +	":-VERS-ALL:+VERS-TLS1.3:%NO_TICKETS" \
>> +	":-CIPHER-ALL:+CHACHA20-POLY1305:+AES-256-GCM:+AES-128-GCM:+AES-128-CCM"
>> +
>> +static int tlsh_nl_put_tls_priorities(struct sk_buff *msg,
>> +				      struct tlsh_sock_info *tsi)
>> +{
>> +	const char *priorities;
>> +	int ret;
>> +
>> +	priorities = tsi->tsi_tls_priorities ?
>> +		tsi->tsi_tls_priorities : KTLS_PRIORITIES;
>> +	ret = nla_put(msg, HANDSHAKE_NL_ATTR_TLS_PRIORITIES,
>> +		      strlen(priorities), priorities);
>> +	return ret < 0 ? ret : 0;
>> +}
>> +
>> +/**
>> + * tlsh_nl_ch_anon_accept - callback to construct a ClientHello netlink reply
>> + * @hsi: kernel handshake parameters to return
>> + * @skb: sk_buff containing NL request
>> + * @nlh: NL request's header
>> + *
>> + * If this function returns a valid pointer, caller must free it
>> + * via nlmsg_free().
>> + */
>> +static struct sk_buff *
>> +tlsh_nl_ch_anon_accept(struct handshake_info *hsi, struct sk_buff *skb,
>> +		       struct nlmsghdr *nlh)
>> +{
>> +	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
>> +						  tsi_handshake_info);
>> +	struct nlattr *entry_attr;
>> +	struct nlmsghdr *hdr;
>> +	struct sk_buff *msg;
>> +	int ret;
>> +
>> +	ret = -ENOMEM;
>> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		goto out;
>> +
>> +	ret = -EMSGSIZE;
>> +	hdr = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
>> +			nlh->nlmsg_type, 0, 0);
>> +	if (!hdr)
>> +		goto out_free;
>> +
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_SOCKFD, hsi->hi_fd);
>> +	if (ret < 0)
>> +		goto out_free;
>> +
>> +	entry_attr = nla_nest_start(msg, HANDSHAKE_NL_ATTR_ACCEPT_RESP);
>> +	if (!entry_attr)
>> +		goto out_cancel;
>> +
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_TLS_TYPE,
>> +			  HANDSHAKE_NL_TLS_TYPE_CLIENTHELLO);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_TLS_AUTH,
>> +			  HANDSHAKE_NL_TLS_AUTH_UNAUTH);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	ret = tlsh_nl_put_tls_priorities(msg, tsi);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	nla_nest_end(msg, entry_attr);
>> +
>> +	nlmsg_end(msg, hdr);
>> +	return msg;
>> +
>> +out_cancel:
>> +	nla_nest_cancel(msg, entry_attr);
>> +out_free:
>> +	nlmsg_free(msg);
>> +out:
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +/**
>> + * tls_client_hello_anon - request an anonymous TLS handshake on a socket
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string, or NULL
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_client_hello_anon(struct socket *sock,
>> +			  void (*done)(void *data, int status), void *data,
>> +			  const char *priorities)
>> +{
>> +	struct tlsh_sock_info *tsi;
>> +	int rc;
>> +
>> +	tsi = tlsh_sock_info_alloc(sock, done, data, priorities);
>> +	if (!tsi)
>> +		return -ENOMEM;
>> +	tsi->tsi_handshake_info.hi_accept = tlsh_nl_ch_anon_accept;
>> +
>> +	rc = handshake_request(&tsi->tsi_handshake_info, GFP_NOWAIT);
>> +	if (rc)
>> +		tlsh_sock_info_free(tsi);
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL(tls_client_hello_anon);
>> +
>> +/**
>> + * tlsh_nl_ch_x509_accept - callback to construct a ClientHello netlink reply
>> + * @hsi: kernel handshake parameters to return
>> + * @skb: sk_buff containing NL request
>> + * @nlh: NL request's header
>> + *
>> + * If this function returns a valid pointer, caller must free it
>> + * via nlmsg_free().
>> + */
>> +static struct sk_buff *
>> +tlsh_nl_ch_x509_accept(struct handshake_info *hsi, struct sk_buff *skb,
>> +		       struct nlmsghdr *nlh)
>> +{
>> +	struct tlsh_sock_info *tsi = container_of(hsi, struct tlsh_sock_info,
>> +						  tsi_handshake_info);
>> +	struct nlattr *entry_attr;
>> +	struct nlmsghdr *hdr;
>> +	struct sk_buff *msg;
>> +	int ret;
>> +
>> +	ret = -ENOMEM;
>> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		goto out;
>> +
>> +	ret = -EMSGSIZE;
>> +	hdr = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
>> +			nlh->nlmsg_type, 0, 0);
>> +	if (!hdr)
>> +		goto out_free;
>> +
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_SOCKFD, hsi->hi_fd);
>> +	if (ret < 0)
>> +		goto out_free;
>> +
>> +	entry_attr = nla_nest_start(msg, HANDSHAKE_NL_ATTR_ACCEPT_RESP);
>> +	if (!entry_attr)
>> +		goto out_cancel;
>> +
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_TLS_TYPE,
>> +			  HANDSHAKE_NL_TLS_TYPE_CLIENTHELLO);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_TLS_AUTH,
>> +			  HANDSHAKE_NL_TLS_AUTH_X509);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_TLS_X509_CERT,
>> +			  tsi->tsi_certificate);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	ret = nla_put_u32(msg, HANDSHAKE_NL_ATTR_TLS_X509_PRIVKEY,
>> +			  tsi->tsi_privkey);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	ret = tlsh_nl_put_tls_priorities(msg, tsi);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +	nla_nest_end(msg, entry_attr);
>> +
>> +	nlmsg_end(msg, hdr);
>> +	return msg;
>> +
>> +out_cancel:
>> +	nla_nest_cancel(msg, entry_attr);
>> +out_free:
>> +	nlmsg_free(msg);
>> +out:
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +/**
>> + * tls_client_hello_x509 - request an x.509-based TLS handshake on a socket
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string
>> + * @cert: serial number of key containing client's x.509 certificate
>> + * @privkey: serial number of key containing client's private key
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_client_hello_x509(struct socket *sock,
>> +			  void (*done)(void *data, int status), void *data,
>> +			  const char *priorities, key_serial_t cert,
>> +			  key_serial_t privkey)
> 
> I wonder: technically TLS 1.3 allows for several keys to be included in the client hello ('key_share' extension resp 'pre_shared_key' extension).
> And the server is expected to pick one of them and return it in the server hello.
> Hence: should't we rather use a keyring here, which should contain all keys to be included in the client hello?
> 
> One possibility would be to require the caller to create a dedicated keyring (ie a pre-process keyring), and link a keys for this transaction to it. With that we could simply add all keys from that keyring, and leave to the caller which key to select.

you don’t need any of such thing. The key_share is just for
establishing the shared secret. You basically use KPP to
create a new public/private keypair and include the public
key in your key_share. So no need to ask the user about it.

This can be be done all internally in the kernel in a safe
Manner. You throw the keypair away after the handshake.

That is why you also don’t want to generate more than
one keypair. It costs time and just makes the handshake
take longer.

If you encounter a server that doesn’t like the key_share
method you prefer as client, it will send a retry and tell
you which ones out of your list of your supported method
you should provide.

Regards

Marcel

