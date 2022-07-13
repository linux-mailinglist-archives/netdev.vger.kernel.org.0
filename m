Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90566573D5B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 21:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiGMTvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 15:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiGMTvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 15:51:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B28B26105;
        Wed, 13 Jul 2022 12:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18F6F61E18;
        Wed, 13 Jul 2022 19:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301C7C34114;
        Wed, 13 Jul 2022 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657741891;
        bh=XQRCQm9cyUaJ0XXRMGwc40cPfbIYv4ZfRw+8YRgjIHQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DSelqltEw5O4kCzj2QnEDMKFD/hcDnPowWC5BzGiuPQX9b0wN6ni+JjLimS2pAvDM
         f571p1A1X4WBPiAY9ZfJmMMIKEA3lP5yKGoWY3tW8DAHjh7xNN0mLH1LwWx+7+bZNv
         zMjpGhu3HpbHeN8XL5bKvH309FaSY8jYU2CWcg6hatRQfeQxRbBArRSZqxe/oYBDEZ
         SnTSIsf92Aw17cmAbYEeo5iTfKEbH5Rp3CEAqUybyBS9C842oK110wyL/GqsnDGHZO
         ZB/TV7toY7VX9VHDCwBPdPt4v6D4sj0vgaVTcr7P8FDAhAP4JexJXuO7dGNr8egrZO
         0WlEqk4iwCEMA==
Date:   Wed, 13 Jul 2022 12:51:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] tracing: devlink: Use static array for string in
 devlink_trap_report even
Message-ID: <20220713125130.0a728bce@kernel.org>
In-Reply-To: <20220712185820.002d9fb5@gandalf.local.home>
References: <20220712185820.002d9fb5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 18:58:20 -0400 Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The trace event devlink_trap_report uses the __dynamic_array() macro to
> determine the size of the input_dev_name field. This is because it needs
> to test the dev field for NULL, and will use "NULL" if it is. But it also
> has the size of the dynamic array as a fixed IFNAMSIZ bytes. This defeats
> the purpose of the dynamic array, as this will reserve that amount of
> bytes on the ring buffer, and to make matters worse, it will even save
> that size in the event as the event expects it to be dynamic (for which it
> is not).
> 
> Since IFNAMSIZ is just 16 bytes, just make it a static array and this will
> remove the meta data from the event that records the size.
> 
> Cc: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
