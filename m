Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E257F5EDA10
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 12:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiI1K26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 06:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiI1K25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 06:28:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD83B5A58;
        Wed, 28 Sep 2022 03:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0357AB82028;
        Wed, 28 Sep 2022 10:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63F2C433B5;
        Wed, 28 Sep 2022 10:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664360933;
        bh=JQkn5onyISFjj1y5bxlLavURPwJ1xFe9vL4EEXhTo/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EakhRokn91Pp1992kA7HFs5zF5pllAU7RzZAFHXXQc85WQ8QJUKYcu4nuV/HpOwua
         ffl3/QVn89OrX2pq7QUkBgajZZ+kIcmr09PS15nScjRBDzP6w85fcBwuohGJsbgFSo
         N1n2grttjk78PxUibf9mc3FBoiUnA1QbbL9/4iz8MzgaQBsg/ermHv8RjFum0UXTRh
         75ksSBs9QpRahaUL2h6GtLDjk5ppyE5Y1EVIGL//HmXxyBptYBYSmQXIS2+ipbhtBO
         6s4L6sr1kNsIKgAaO1dShscquKh6OxVvTnXIMHnatoPk7Xet4B0nOY0uck8Dte/X8l
         3z+pJ7UFiRT8A==
Date:   Wed, 28 Sep 2022 13:28:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shenjian15@huawei.com,
        lanhao@huawei.com
Subject: Re: [PATCH net-next 1/4] net: hns3: refine the tcam key convert
 handle
Message-ID: <YzQh4Zu3Md1+Npeo@unreal>
References: <20220927111205.18060-1-huangguangbin2@huawei.com>
 <20220927111205.18060-2-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927111205.18060-2-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 07:12:02PM +0800, Guangbin Huang wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> The expression '(k ^ ~v)' is exaclty '(k & v)', and
> '(k & v) & k' is exaclty 'k & v'. So simplify the
> expression for tcam key convert.
> 
> It also add necessary brackets for them.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index 495b639b0dc2..59bfacc687c9 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -827,15 +827,10 @@ struct hclge_vf_vlan_cfg {
>   * Then for input key(k) and mask(v), we can calculate the value by
>   * the formulae:
>   *	x = (~k) & v
> - *	y = (k ^ ~v) & k
> + *	y = k & v
>   */
> -#define calc_x(x, k, v) (x = ~(k) & (v))
> -#define calc_y(y, k, v) \
> -	do { \
> -		const typeof(k) _k_ = (k); \
> -		const typeof(v) _v_ = (v); \
> -		(y) = (_k_ ^ ~_v_) & (_k_); \
> -	} while (0)
> +#define calc_x(x, k, v) ((x) = ~(k) & (v))
> +#define calc_y(y, k, v) ((y) = (k) & (v))

Can you please explain why do you need special define for boolean AND?

Thanks

>  
>  #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
>  #define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
> -- 
> 2.33.0
> 
