Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F185ED2C7
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiI1BtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiI1BtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:49:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577961EE74E;
        Tue, 27 Sep 2022 18:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA27361CD9;
        Wed, 28 Sep 2022 01:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D70DC433D6;
        Wed, 28 Sep 2022 01:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664329748;
        bh=fQvNSErz3iK0Qq/CCZWvUeJTMB9Y5fYJ7z2Vx+QiOLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SnqeOnQbcGrEWG57GupmTtyzOANZNddaPKDa5hYCEY9sK5N1EpFbAFodO6VPxXw6K
         WBQRKYbdhc+EfQKThr3rnm+b/38FE/vMXxQLUm8Jsrejy35zBzwfjO5C57mOpeva01
         hyiNyeVoTp4ad1IYt4PaP9W+bdBTcbObnl+/ZwqSLM9O6LpOMGogM/vFuNNcwSL4h2
         NpSUram5JRwpu4l7AShBZg+GM/DZgPf//yuty7wtLLvnqPB82OmOL/xeB2k19EiScO
         56gugkitHFhZ0OkG3r6IAUs9/cCAFVRTvd2wfb3ocwRwdiv2tGM8mqFxgS2u/u97ul
         jqoKsfN4Db2sw==
Date:   Tue, 27 Sep 2022 18:49:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/8] net: dsa: felix: offload per-tc max SDU
 from tc-taprio
Message-ID: <20220927184906.1cc33db2@kernel.org>
In-Reply-To: <20220927234746.1823648-4-vladimir.oltean@nxp.com>
References: <20220927234746.1823648-1-vladimir.oltean@nxp.com>
        <20220927234746.1823648-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 02:47:41 +0300 Vladimir Oltean wrote:
> +static int vsc9959_qos_query_caps(struct tc_query_caps_base *base)
> +{
> +	switch (base->type) {
> +	case TC_SETUP_QDISC_TAPRIO: {
> +		struct tc_taprio_caps *caps = base->caps;
> +
> +		caps->supports_queue_max_sdu = true;

Compilers don't like the implicit fallthru here and on the next patch,
which seems semi-legit.

> +	}
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
