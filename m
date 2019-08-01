Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886707D95F
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 12:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbfHAK2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 06:28:47 -0400
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:39263 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730649AbfHAK2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 06:28:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 9705A18122414;
        Thu,  1 Aug 2019 10:28:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3874:4321:4605:5007:7514:8957:9010:10004:10848:11026:11232:11233:11473:11657:11658:11914:12043:12291:12296:12297:12438:12555:12683:12740:12760:12895:12986:13095:13439:14181:14659:14721:21080:21427:21433:21450:21451:21627:30054:30070:30085:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: wash33_2f3fa9b28402d
X-Filterd-Recvd-Size: 5314
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Thu,  1 Aug 2019 10:28:44 +0000 (UTC)
Message-ID: <209f7fe62e2a79cd8c02b104b8e3babdd16bff30.camel@perches.com>
Subject: Re: [PATCH net] ibmveth: use net_err_ratelimited when
 set_multicast_list
From:   Joe Perches <joe@perches.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Thu, 01 Aug 2019 03:28:43 -0700
In-Reply-To: <20190801090347.8258-1-liuhangbin@gmail.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-01 at 17:03 +0800, Hangbin Liu wrote:
> When setting lots of multicast list on ibmveth, e.g. add 3000 membership on a
> multicast group, the following error message flushes our log file
> 
> 8507    [  901.478251] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> ...
> 1718386 [ 5636.808658] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
> 
> We got 1.5 million lines of messages in 1.3h. Let's replace netdev_err() by
> net_err_ratelimited() to avoid this issue. I don't use netdev_err_once() in
> case h_multicast_ctrl() return different lpar_rc types.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  drivers/net/ethernet/ibm/ibmveth.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index d654c234aaf7..3b9406a4ca92 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1446,9 +1446,11 @@ static void ibmveth_set_multicast_list(struct net_device *netdev)
>  						   IbmVethMcastAddFilter,
>  						   mcast_addr);
>  			if (lpar_rc != H_SUCCESS) {
> -				netdev_err(netdev, "h_multicast_ctrl rc=%ld "
> -					   "when adding an entry to the filter "
> -					   "table\n", lpar_rc);
> +				net_err_ratelimited("%s %s%s: h_multicast_ctrl rc=%ld when adding an entry to the filter table\n",
> +						    ibmveth_driver_name,
> +						    netdev_name(netdev),
> +						    netdev_reg_state(netdev),
> +						    lpar_rc);

Perhaps add the netdev_<level>_ratelimited variants and use that instead

Somthing like:

---
 include/linux/netdevice.h | 54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88292953aa6f..37116019e14f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4737,6 +4737,60 @@ do {								\
 #define netdev_info_once(dev, fmt, ...) \
 	netdev_level_once(KERN_INFO, dev, fmt, ##__VA_ARGS__)
 
+#define netdev_level_ratelimited(netdev_level, dev, fmt, ...)		\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		netdev_level(dev, fmt, ##__VA_ARGS__);			\
+} while (0)
+
+#define netdev_emerg_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_emerg, dev, fmt, ##__VA_ARGS__)
+#define netdev_alert_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_alert, dev, fmt, ##__VA_ARGS__)
+#define netdev_crit_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_crit, dev, fmt, ##__VA_ARGS__)
+#define netdev_err_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_err, dev, fmt, ##__VA_ARGS__)
+#define netdev_warn_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_warn, dev, fmt, ##__VA_ARGS__)
+#define netdev_notice_ratelimited(dev, fmt, ...)			\
+	netdev_level_ratelimited(netdev_notice, dev, fmt, ##__VA_ARGS__)
+#define netdev_info_ratelimited(dev, fmt, ...)				\
+	netdev_level_ratelimited(netdev_info, dev, fmt, ##__VA_ARGS__)
+
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
+#define netdev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (DYNAMIC_DEBUG_BRANCH(descriptor) &&				\
+	    __ratelimit(&_rs))						\
+		__dynamic_netdev_dbg(&descriptor, dev, fmt,		\
+				     ##__VA_ARGS__);			\
+} while (0)
+#elif defined(DEBUG)
+#define netdev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		netdev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
+} while (0)
+#else
+#define netdev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	if (0)								\
+		netdev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
+} while (0)
+#endif
+
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 


