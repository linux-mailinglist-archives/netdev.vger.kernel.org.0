Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE60E7DC7F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbfHANZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 09:25:42 -0400
Received: from mail5.windriver.com ([192.103.53.11]:38808 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730706AbfHANZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 09:25:42 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x71DNfDm032295
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Thu, 1 Aug 2019 06:24:18 -0700
Received: from [128.224.155.90] (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.468.0; Thu, 1 Aug
 2019 06:23:40 -0700
Subject: Re: [PATCH] tipc: compat: allow tipc commands without arguments
To:     Taras Kondratiuk <takondra@cisco.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <xe-linux-external@cisco.com>,
        <stable@vger.kernel.org>
References: <20190729221507.48893-1-takondra@cisco.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <605b6a6e-8bdd-c95f-ac00-9dd895fcc6a3@windriver.com>
Date:   Thu, 1 Aug 2019 21:12:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190729221507.48893-1-takondra@cisco.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.155.90]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 6:15 AM, Taras Kondratiuk wrote:
> Commit 2753ca5d9009 ("tipc: fix uninit-value in tipc_nl_compat_doit")
> broke older tipc tools that use compat interface (e.g. tipc-config from
> tipcutils package):
> 
> % tipc-config -p
> operation not supported
> 
> The commit started to reject TIPC netlink compat messages that do not
> have attributes. It is too restrictive because some of such messages are
> valid (they don't need any arguments):
> 
> % grep 'tx none' include/uapi/linux/tipc_config.h
> #define  TIPC_CMD_NOOP              0x0000    /* tx none, rx none */
> #define  TIPC_CMD_GET_MEDIA_NAMES   0x0002    /* tx none, rx media_name(s) */
> #define  TIPC_CMD_GET_BEARER_NAMES  0x0003    /* tx none, rx bearer_name(s) */
> #define  TIPC_CMD_SHOW_PORTS        0x0006    /* tx none, rx ultra_string */
> #define  TIPC_CMD_GET_REMOTE_MNG    0x4003    /* tx none, rx unsigned */
> #define  TIPC_CMD_GET_MAX_PORTS     0x4004    /* tx none, rx unsigned */
> #define  TIPC_CMD_GET_NETID         0x400B    /* tx none, rx unsigned */
> #define  TIPC_CMD_NOT_NET_ADMIN     0xC001    /* tx none, rx none */
> 
> This patch relaxes the original fix and rejects messages without
> arguments only if such arguments are expected by a command (reg_type is
> non zero).
> 
> Fixes: 2753ca5d9009 ("tipc: fix uninit-value in tipc_nl_compat_doit")
> Cc: stable@vger.kernel.org
> Signed-off-by: Taras Kondratiuk <takondra@cisco.com>

Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
> The patch is based on v5.3-rc2.
> 
>  net/tipc/netlink_compat.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
> index d86030ef1232..e135d4e11231 100644
> --- a/net/tipc/netlink_compat.c
> +++ b/net/tipc/netlink_compat.c
> @@ -55,6 +55,7 @@ struct tipc_nl_compat_msg {
>  	int rep_type;
>  	int rep_size;
>  	int req_type;
> +	int req_size;
>  	struct net *net;
>  	struct sk_buff *rep;
>  	struct tlv_desc *req;
> @@ -257,7 +258,8 @@ static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
>  	int err;
>  	struct sk_buff *arg;
>  
> -	if (msg->req_type && !TLV_CHECK_TYPE(msg->req, msg->req_type))
> +	if (msg->req_type && (!msg->req_size ||
> +			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
>  		return -EINVAL;
>  
>  	msg->rep = tipc_tlv_alloc(msg->rep_size);
> @@ -354,7 +356,8 @@ static int tipc_nl_compat_doit(struct tipc_nl_compat_cmd_doit *cmd,
>  {
>  	int err;
>  
> -	if (msg->req_type && !TLV_CHECK_TYPE(msg->req, msg->req_type))
> +	if (msg->req_type && (!msg->req_size ||
> +			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
>  		return -EINVAL;
>  
>  	err = __tipc_nl_compat_doit(cmd, msg);
> @@ -1278,8 +1281,8 @@ static int tipc_nl_compat_recv(struct sk_buff *skb, struct genl_info *info)
>  		goto send;
>  	}
>  
> -	len = nlmsg_attrlen(req_nlh, GENL_HDRLEN + TIPC_GENL_HDRLEN);
> -	if (!len || !TLV_OK(msg.req, len)) {
> +	msg.req_size = nlmsg_attrlen(req_nlh, GENL_HDRLEN + TIPC_GENL_HDRLEN);
> +	if (msg.req_size && !TLV_OK(msg.req, msg.req_size)) {
>  		msg.rep = tipc_get_err_tlv(TIPC_CFG_NOT_SUPPORTED);
>  		err = -EOPNOTSUPP;
>  		goto send;
> 
