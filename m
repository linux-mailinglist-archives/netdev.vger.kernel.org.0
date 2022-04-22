Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B714C50B1F6
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445010AbiDVHtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242661AbiDVHtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:49:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F87434B4;
        Fri, 22 Apr 2022 00:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A88A1B829DC;
        Fri, 22 Apr 2022 07:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E2BC385A0;
        Fri, 22 Apr 2022 07:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650613562;
        bh=d7DdfLVHBzoMwY9s9afOMHivuS5z7UO53y+qRExaI4g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g2Ix2CmD+h6XYXS+ZxSj7/TtWfmzDMgqg280d2chhORi0tqBDGCr+AcUsnJT4qRBb
         sRRUcsC04Us16r9ELqy1MpknoMXvx/MQwBJ/Lj8FA9QDa+iWTjowciFQbg0tJC60lH
         NHyR5m3HH5jKcsl/CpJ4cIMq5MOMudSJlSeYUXjMIXXzHdXi+SJcZZLPsfS2QQcD94
         qV9oD7mYtKr1cGETBv0p3SuxvN9KxbHSixLkV5FaQ/UYL3YpoPzwpHBcjD2NCd18TV
         2SMpZmgormeA4vc4aG4ohUEpEhor7wrPAiUYdKPnsH0zhqZXrm17dGVECoJSaWtrMy
         9kP2dbAoyV7xg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bernard Zhao <zhaojunkui2008@126.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re: [PATCH] mediatek/mt7601u: add debugfs exit function
References: <20220422070325.465918-1-zhaojunkui2008@126.com>
Date:   Fri, 22 Apr 2022 10:45:57 +0300
In-Reply-To: <20220422070325.465918-1-zhaojunkui2008@126.com> (Bernard Zhao's
        message of "Fri, 22 Apr 2022 00:03:25 -0700")
Message-ID: <87k0bhmuh6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard Zhao <zhaojunkui2008@126.com> writes:

> When mt7601u loaded, there are two cases:
> First when mt7601u is loaded, in function mt7601u_probe, if
> function mt7601u_probe run into error lable err_hw,
> mt7601u_cleanup didn`t cleanup the debugfs node.
> Second when the module disconnect, in function mt7601u_disconnect,
> mt7601u_cleanup didn`t cleanup the debugfs node.
> This patch add debugfs exit function and try to cleanup debugfs
> node when mt7601u loaded fail or unloaded.
>
> Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
> ---
>  .../net/wireless/mediatek/mt7601u/debugfs.c   | 25 +++++++++++--------
>  drivers/net/wireless/mediatek/mt7601u/init.c  |  5 ++++
>  .../net/wireless/mediatek/mt7601u/mt7601u.h   |  4 +++
>  3 files changed, 24 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> index 20669eacb66e..1ae3d75d3c9b 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
> @@ -124,17 +124,22 @@ DEFINE_SHOW_ATTRIBUTE(mt7601u_eeprom_param);
>  
>  void mt7601u_init_debugfs(struct mt7601u_dev *dev)
>  {
> -	struct dentry *dir;
> -
> -	dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
> -	if (!dir)
> +	dev->root_dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
> +	if (!dev->root_dir)
>  		return;
>  
> -	debugfs_create_u8("temperature", 0400, dir, &dev->raw_temp);
> -	debugfs_create_u32("temp_mode", 0400, dir, &dev->temp_mode);
> +	debugfs_create_u8("temperature", 0400, dev->root_dir, &dev->raw_temp);
> +	debugfs_create_u32("temp_mode", 0400, dev->root_dir, &dev->temp_mode);
> +
> +	debugfs_create_u32("regidx", 0600, dev->root_dir, &dev->debugfs_reg);
> +	debugfs_create_file("regval", 0600, dev->root_dir, dev, &fops_regval);
> +	debugfs_create_file("ampdu_stat", 0400, dev->root_dir, dev, &mt7601u_ampdu_stat_fops);
> +	debugfs_create_file("eeprom_param", 0400, dev->root_dir, dev, &mt7601u_eeprom_param_fops);
> +}
>  
> -	debugfs_create_u32("regidx", 0600, dir, &dev->debugfs_reg);
> -	debugfs_create_file("regval", 0600, dir, dev, &fops_regval);
> -	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt7601u_ampdu_stat_fops);
> -	debugfs_create_file("eeprom_param", 0400, dir, dev, &mt7601u_eeprom_param_fops);
> +void mt7601u_exit_debugfs(struct mt7601u_dev *dev)
> +{
> +	if (!dev->root_dir)
> +		return;
> +	debugfs_remove(dev->root_dir);

debugfs_remove() has IS_ERR_OR_NULL() check, so no need to check for
null here.

>  }
> diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
> index 5d9e952b2966..1e905ef2ed19 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/init.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/init.c
> @@ -427,6 +427,9 @@ void mt7601u_cleanup(struct mt7601u_dev *dev)
>  	mt7601u_stop_hardware(dev);
>  	mt7601u_dma_cleanup(dev);
>  	mt7601u_mcu_cmd_deinit(dev);
> +#ifdef CONFIG_DEBUG_FS
> +	mt7601u_exit_debugfs(dev);
> +#endif
>  }
>  
>  struct mt7601u_dev *mt7601u_alloc_device(struct device *pdev)
> @@ -625,7 +628,9 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
>  	if (ret)
>  		return ret;
>  
> +#ifdef CONFIG_DEBUG_FS
>  	mt7601u_init_debugfs(dev);
> +#endif

Are these two ifdefs really needed? debugfs functions are empty
functions when CONFIG_DEBUG_FS is disabled.

> --- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
> +++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
> @@ -242,6 +242,9 @@ struct mt7601u_dev {
>  	u32 rf_pa_mode[2];
>  
>  	struct mac_stats stats;
> +#ifdef CONFIG_DEBUG_FS
> +	struct dentry *root_dir;
> +#endif

I would remove this ifdef, it's just saving one pointer size. Less
ifdefs we have the better.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
