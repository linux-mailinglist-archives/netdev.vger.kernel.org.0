Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F985340BF
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 17:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245326AbiEYPvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 11:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245369AbiEYPvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 11:51:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B39AF315
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 08:50:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA0A5B81E01
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 15:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4318CC385B8;
        Wed, 25 May 2022 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653493855;
        bh=sM2prxCJyfHnv0JqWJO/b1Dyf0IzHcmxkDXplFr31vE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vmbkcfv61BL6jebgtdQHMGJZawIsTnVbXBj2g6j9xdSAijoK2hs/p9dhtsPzabyI1
         0vBPeDu2G6LiK1o7O8R5Y2tVSL8tutHNjjNr75cgUwWPy5LtdcqUjQ2Nw0VSCjQdPn
         dDkbxUvbgGK2kl4dfDRg8h6EH8yn2k9nro1V2EgBhINAi4lG75Do0BBOG49t2n4m7q
         yS+7jthaKcqL3paeMTkybIgiImOeJhyDCNoXfv2g4naUx/dWt0g3n5xij/FkpLkRhs
         qHed9FiOHPa6iNhbyadtZsICUBGvX+Fagr9w/IS6CB2hoaWPksVuHNT25Fmf6upCYb
         jDT9SYqr188XQ==
Date:   Wed, 25 May 2022 08:50:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220525085054.70f297ac@kernel.org>
In-Reply-To: <Yo3KvfgTVTFM/JHL@nanopsycho>
References: <20220429114535.64794e94@kernel.org>
        <Ymw8jBoK3Vx8A/uq@nanopsycho>
        <20220429153845.5d833979@kernel.org>
        <YmzW12YL15hAFZRV@nanopsycho>
        <20220502073933.5699595c@kernel.org>
        <YotW74GJWt0glDnE@nanopsycho>
        <20220523105640.36d1e4b3@kernel.org>
        <Yox/TkxkTUtd0RMM@nanopsycho>
        <YozsUWj8TQPi7OkM@nanopsycho>
        <20220524110057.38f3ca0d@kernel.org>
        <Yo3KvfgTVTFM/JHL@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 May 2022 08:20:45 +0200 Jiri Pirko wrote:
> >We talked about this earlier in the thread, I think. If you need both
> >info and flash per LC just make them a separate devlink instance and
> >let them have all the objects they need. Then just put the instance
> >name under lc info.  
> 
> I don't follow :/ What do you mean be "separate devlink instance" here?
> Could you draw me an example?

Separate instance:

	for (i = 0; i < sw->num_lcs; i++) {
		devlink_register(&sw->lc_dl[i]);
		devlink_line_card_link(&sw->lc[i], &sw->lc_dl[i]);
	}

then report that under the linecard

	nla_nest_start(msg, DEVLINK_SUBORDINATE_INSTANCE);
	devlink_nl_put_handle(msg, lc->devlink);
	nla_nest_end(msg...)

then user can update the linecard like any devlink instance, switch,
NIC etc. It's better code reuse and I don't see any downside, TBH.
