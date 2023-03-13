Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015976B85E2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCMXJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCMXJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:09:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB73580E35;
        Mon, 13 Mar 2023 16:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6CB7B81644;
        Mon, 13 Mar 2023 23:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D29FC433D2;
        Mon, 13 Mar 2023 23:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678748919;
        bh=sX1ACa8gZtf3/q/1WhrJLcKXpRal2/Mfj8Av3ufc8ns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xq2keRQghnMwbefmaBZ6xsMXuSwSa74vY/KqoUPNTulknCK+0G3emZRmqK08+JfQz
         Wmq5qkpWG3uCeLD9ZJhv0nSjFHXhxM7u7UN4+rPq15yDjUIPdX7y7GjfxAySEV6PzG
         fU4e/ytmllN6e7nNlxktChKsNno30AqCsbjfYYkkVYtuvLeto49+T9mdv0CjYR6brK
         hfOY06by5ZFfohpilacFLnv0vrfNxghjWd4mde3IPriMs4PzCKf8OMJRqCk1vb4aJx
         njMVGgCahhwrPovtJ+/7vMwuXq8nSc3uJtWGB+JeVZqXNHeOp89I70C7XTJxTs3Hq4
         jwRcs1litggVw==
Date:   Mon, 13 Mar 2023 16:08:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <haozhe.chang@mediatek.com>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Oliver Neukum <oneukum@suse.com>,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        "open list:INTEL WWAN IOSM DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:REMOTE PROCESSOR MESSAGING (RPMSG) WWAN CONTROL..." 
        <linux-remoteproc@vger.kernel.org>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, <lambert.wang@mediatek.com>,
        <xiayu.zhang@mediatek.com>, <hua.yang@mediatek.com>
Subject: Re: [PATCH RESEND net-next v7] wwan: core: Support slicing in port
 TX flow of WWAN subsystem
Message-ID: <20230313160837.77f4ced0@kernel.org>
In-Reply-To: <20230308081939.5512-1-haozhe.chang@mediatek.com>
References: <20230308081939.5512-1-haozhe.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Mar 2023 16:19:35 +0800 haozhe.chang@mediatek.com wrote:
>  /**
>   * wwan_create_port - Add a new WWAN port
>   * @parent: Device to use as parent and shared by all WWAN ports
>   * @type: WWAN port type
>   * @ops: WWAN port operations
> + * @frag_len: WWAN port TX fragments length, if WWAN_NO_FRAGMENT is set,
> + *            the WWAN core don't fragment control packages.
> + * @headroom_len: WWAN port TX fragments reserved headroom length, if WWAN_NO_HEADROOM
> + *                is set, the WWAN core don't reserve headroom in control packages.
>   * @drvdata: Pointer to caller driver data
>   *
>   * Allocate and register a new WWAN port. The port will be automatically exposed
> @@ -86,6 +100,8 @@ struct wwan_port_ops {
>  struct wwan_port *wwan_create_port(struct device *parent,
>  				   enum wwan_port_type type,
>  				   const struct wwan_port_ops *ops,
> +				   size_t frag_len,
> +				   unsigned int headroom_len,
>  				   void *drvdata);
>  

Too many arguments, and poor extensibility.
Please wrap the new params into a capability struct:

struct wwan_port_caps {
	unsigned int frag_len;
	unsigned int headroom_len;
};

pass a pointer to this kind of structure in.

Next time someone needs to add a quirk they can just add a field and
won't need to change all the drivers.
