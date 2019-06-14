Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1058845659
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfFNHbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:31:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:64176 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbfFNHbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 03:31:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 00:31:38 -0700
X-ExtLoop1: 1
Received: from jrissane-mobl.ger.corp.intel.com (HELO jrissane-mobl1.fi.intel.com) ([10.237.67.34])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jun 2019 00:31:36 -0700
Message-ID: <dc047560cd3ff0cced5cdb911362d5d8e13c633b.camel@linux.intel.com>
Subject: Re: [PATCH] 6lowpan: no need to check return value of
 debugfs_create functions
From:   Jukka Rissanen <jukka.rissanen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Fri, 14 Jun 2019 10:31:35 +0300
In-Reply-To: <20190614071423.GA18533@kroah.com>
References: <20190614071423.GA18533@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Acked-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>

Cheers,
Jukka

On Fri, 2019-06-14 at 09:14 +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic
> should
> never do something different based on this.
> 
> Because we don't care if debugfs works or not, this trickles back a
> bit
> so we can clean things up by making some functions return void
> instead
> of an error value that is never going to fail.
> 
> Cc: Alexander Aring <alex.aring@gmail.com>
> Cc: Jukka Rissanen <jukka.rissanen@linux.intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: linux-wpan@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/6lowpan/6lowpan_i.h | 16 ++-----
>  net/6lowpan/core.c      |  8 +---
>  net/6lowpan/debugfs.c   | 97 +++++++++++--------------------------
> ----
>  3 files changed, 32 insertions(+), 89 deletions(-)
> 
> diff --git a/net/6lowpan/6lowpan_i.h b/net/6lowpan/6lowpan_i.h
> index 53cf446ce2e3..01853cec0209 100644
> --- a/net/6lowpan/6lowpan_i.h
> +++ b/net/6lowpan/6lowpan_i.h
> @@ -18,24 +18,16 @@ extern const struct ndisc_ops lowpan_ndisc_ops;
>  int addrconf_ifid_802154_6lowpan(u8 *eui, struct net_device *dev);
>  
>  #ifdef CONFIG_6LOWPAN_DEBUGFS
> -int lowpan_dev_debugfs_init(struct net_device *dev);
> +void lowpan_dev_debugfs_init(struct net_device *dev);
>  void lowpan_dev_debugfs_exit(struct net_device *dev);
>  
> -int __init lowpan_debugfs_init(void);
> +void __init lowpan_debugfs_init(void);
>  void lowpan_debugfs_exit(void);
>  #else
> -static inline int lowpan_dev_debugfs_init(struct net_device *dev)
> -{
> -	return 0;
> -}
> -
> +static inline void lowpan_dev_debugfs_init(struct net_device *dev) {
> }
>  static inline void lowpan_dev_debugfs_exit(struct net_device *dev) {
> }
>  
> -static inline int __init lowpan_debugfs_init(void)
> -{
> -	return 0;
> -}
> -
> +static inline void __init lowpan_debugfs_init(void) { }
>  static inline void lowpan_debugfs_exit(void) { }
>  #endif /* CONFIG_6LOWPAN_DEBUGFS */
>  
> diff --git a/net/6lowpan/core.c b/net/6lowpan/core.c
> index 2d68351f1ac4..a068757eabaf 100644
> --- a/net/6lowpan/core.c
> +++ b/net/6lowpan/core.c
> @@ -42,9 +42,7 @@ int lowpan_register_netdevice(struct net_device
> *dev,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = lowpan_dev_debugfs_init(dev);
> -	if (ret < 0)
> -		unregister_netdevice(dev);
> +	lowpan_dev_debugfs_init(dev);
>  
>  	return ret;
>  }
> @@ -152,9 +150,7 @@ static int __init lowpan_module_init(void)
>  {
>  	int ret;
>  
> -	ret = lowpan_debugfs_init();
> -	if (ret < 0)
> -		return ret;
> +	lowpan_debugfs_init();
>  
>  	ret = register_netdevice_notifier(&lowpan_notifier);
>  	if (ret < 0) {
> diff --git a/net/6lowpan/debugfs.c b/net/6lowpan/debugfs.c
> index f5a8eec9d7a3..1c140af06d52 100644
> --- a/net/6lowpan/debugfs.c
> +++ b/net/6lowpan/debugfs.c
> @@ -163,11 +163,11 @@ static const struct file_operations
> lowpan_ctx_pfx_fops = {
>  	.release	= single_release,
>  };
>  
> -static int lowpan_dev_debugfs_ctx_init(struct net_device *dev,
> -				       struct dentry *ctx, u8 id)
> +static void lowpan_dev_debugfs_ctx_init(struct net_device *dev,
> +					struct dentry *ctx, u8 id)
>  {
>  	struct lowpan_dev *ldev = lowpan_dev(dev);
> -	struct dentry *dentry, *root;
> +	struct dentry *root;
>  	char buf[32];
>  
>  	WARN_ON_ONCE(id > LOWPAN_IPHC_CTX_TABLE_SIZE);
> @@ -175,34 +175,18 @@ static int lowpan_dev_debugfs_ctx_init(struct
> net_device *dev,
>  	sprintf(buf, "%d", id);
>  
>  	root = debugfs_create_dir(buf, ctx);
> -	if (!root)
> -		return -EINVAL;
>  
> -	dentry = debugfs_create_file_unsafe("active", 0644, root,
> -					    &ldev->ctx.table[id],
> -					    &lowpan_ctx_flag_active_fop
> s);
> -	if (!dentry)
> -		return -EINVAL;
> +	debugfs_create_file("active", 0644, root, &ldev->ctx.table[id],
> +			    &lowpan_ctx_flag_active_fops);
>  
> -	dentry = debugfs_create_file_unsafe("compression", 0644, root,
> -					    &ldev->ctx.table[id],
> -					    &lowpan_ctx_flag_c_fops);
> -	if (!dentry)
> -		return -EINVAL;
> -
> -	dentry = debugfs_create_file("prefix", 0644, root,
> -				     &ldev->ctx.table[id],
> -				     &lowpan_ctx_pfx_fops);
> -	if (!dentry)
> -		return -EINVAL;
> +	debugfs_create_file("compression", 0644, root, &ldev-
> >ctx.table[id],
> +			    &lowpan_ctx_flag_c_fops);
>  
> -	dentry = debugfs_create_file_unsafe("prefix_len", 0644, root,
> -					    &ldev->ctx.table[id],
> -					    &lowpan_ctx_plen_fops);
> -	if (!dentry)
> -		return -EINVAL;
> +	debugfs_create_file("prefix", 0644, root, &ldev->ctx.table[id],
> +			    &lowpan_ctx_pfx_fops);
>  
> -	return 0;
> +	debugfs_create_file("prefix_len", 0644, root, &ldev-
> >ctx.table[id],
> +			    &lowpan_ctx_plen_fops);
>  }
>  
>  static int lowpan_context_show(struct seq_file *file, void *offset)
> @@ -242,64 +226,39 @@ static int lowpan_short_addr_get(void *data,
> u64 *val)
>  DEFINE_DEBUGFS_ATTRIBUTE(lowpan_short_addr_fops,
> lowpan_short_addr_get, NULL,
>  			 "0x%04llx\n");
>  
> -static int lowpan_dev_debugfs_802154_init(const struct net_device
> *dev,
> +static void lowpan_dev_debugfs_802154_init(const struct net_device
> *dev,
>  					  struct lowpan_dev *ldev)
>  {
> -	struct dentry *dentry, *root;
> +	struct dentry *root;
>  
>  	if (!lowpan_is_ll(dev, LOWPAN_LLTYPE_IEEE802154))
> -		return 0;
> +		return;
>  
>  	root = debugfs_create_dir("ieee802154", ldev->iface_debugfs);
> -	if (!root)
> -		return -EINVAL;
> -
> -	dentry = debugfs_create_file_unsafe("short_addr", 0444, root,
> -					    lowpan_802154_dev(dev)-
> >wdev->ieee802154_ptr,
> -					    &lowpan_short_addr_fops);
> -	if (!dentry)
> -		return -EINVAL;
>  
> -	return 0;
> +	debugfs_create_file("short_addr", 0444, root,
> +			    lowpan_802154_dev(dev)->wdev-
> >ieee802154_ptr,
> +			    &lowpan_short_addr_fops);
>  }
>  
> -int lowpan_dev_debugfs_init(struct net_device *dev)
> +void lowpan_dev_debugfs_init(struct net_device *dev)
>  {
>  	struct lowpan_dev *ldev = lowpan_dev(dev);
> -	struct dentry *contexts, *dentry;
> -	int ret, i;
> +	struct dentry *contexts;
> +	int i;
>  
>  	/* creating the root */
>  	ldev->iface_debugfs = debugfs_create_dir(dev->name,
> lowpan_debugfs);
> -	if (!ldev->iface_debugfs)
> -		goto fail;
>  
>  	contexts = debugfs_create_dir("contexts", ldev->iface_debugfs);
> -	if (!contexts)
> -		goto remove_root;
> -
> -	dentry = debugfs_create_file("show", 0644, contexts,
> -				     &lowpan_dev(dev)->ctx,
> -				     &lowpan_context_fops);
> -	if (!dentry)
> -		goto remove_root;
> -
> -	for (i = 0; i < LOWPAN_IPHC_CTX_TABLE_SIZE; i++) {
> -		ret = lowpan_dev_debugfs_ctx_init(dev, contexts, i);
> -		if (ret < 0)
> -			goto remove_root;
> -	}
>  
> -	ret = lowpan_dev_debugfs_802154_init(dev, ldev);
> -	if (ret < 0)
> -		goto remove_root;
> +	debugfs_create_file("show", 0644, contexts, &lowpan_dev(dev)-
> >ctx,
> +			    &lowpan_context_fops);
>  
> -	return 0;
> +	for (i = 0; i < LOWPAN_IPHC_CTX_TABLE_SIZE; i++)
> +		lowpan_dev_debugfs_ctx_init(dev, contexts, i);
>  
> -remove_root:
> -	lowpan_dev_debugfs_exit(dev);
> -fail:
> -	return -EINVAL;
> +	lowpan_dev_debugfs_802154_init(dev, ldev);
>  }
>  
>  void lowpan_dev_debugfs_exit(struct net_device *dev)
> @@ -307,13 +266,9 @@ void lowpan_dev_debugfs_exit(struct net_device
> *dev)
>  	debugfs_remove_recursive(lowpan_dev(dev)->iface_debugfs);
>  }
>  
> -int __init lowpan_debugfs_init(void)
> +void __init lowpan_debugfs_init(void)
>  {
>  	lowpan_debugfs = debugfs_create_dir("6lowpan", NULL);
> -	if (!lowpan_debugfs)
> -		return -EINVAL;
> -
> -	return 0;
>  }
>  
>  void lowpan_debugfs_exit(void)

