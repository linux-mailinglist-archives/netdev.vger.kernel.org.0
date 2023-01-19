Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A43674BB8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjATFHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjATFGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:06:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E2985350;
        Thu, 19 Jan 2023 20:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5B87B826FD;
        Thu, 19 Jan 2023 19:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BDBC433EF;
        Thu, 19 Jan 2023 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674155062;
        bh=d2g00Jw6tz6BD9hWtgN3/3p+tv5fhKJDDTMQdPfD77w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XJK/TUlq4tP+RkiqqZMUb2dnclna7fks8twJ14kwfW9eTsO4vDwjRbtTryPOG8NG8
         6BrTOMalyK+BKkySa3GoZHZIbrX3hy5hTYi5+Fb7knfdUsbdBcuQGxQIu0OIkgXMZS
         wVRNy7K7N1sSZDuaq2Qtz6uqxPp5Zewc792MxH0ruNWxOjNrT4zD/RLdXGEgD79MuT
         dNU7v5aJ3zc+SjEwPNoZMJhwejz7A9JwwoIB+gP2nH9IACxwdbd8Hde/YBGF0aqgdd
         0puiEQF0ONcQkenMGqssL14EtRKODOdmAHV/oaw0BbF4nZ9PgpRvP0DBbhMVycxFZT
         FMg5Evctwh7fw==
Date:   Thu, 19 Jan 2023 11:04:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     netdev@vger.kernel.org, leit@fb.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        sa+renesas@sang-engineering.com, linux-kernel@vger.kernel.org,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: Re: [RFC PATCH v2] netpoll: Remove 4s sleep during carrier
 detection
Message-ID: <20230119110421.3efc0f6b@kernel.org>
In-Reply-To: <20230119180008.2156048-1-leitao@debian.org>
References: <20230119164448.1348272-1-leitao@debian.org>
        <20230119180008.2156048-1-leitao@debian.org>
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

On Thu, 19 Jan 2023 10:00:08 -0800 Breno Leitao wrote:
> This patch proposes to remove the msleep(4s) during netpoll_setup() if
> the carrier appears instantly.
> 
> Modern NICs do not seem to have this bouncing problem anymore, and this
> sleep slows down the machine boot unnecessarily

We should mention in the message that the wait is counter-productive on
servers which have BMC communicating over NC-SI via the same NIC as gets
used for netconsole. BMC will keep the PHY up, hence the carrier
appearing instantly.

We could add a smaller delay, but really having instant carrier and
then loosing it seems like a driver bug, so let's try to rip the band
aid off and ask for forgiveness instead.


Few extra process rules:
 - don't repost another version within 24h,
 - keep a changelog under --- 
 - add tree name to the tag - [PATCH net-next]

Also, I'd just go for PATCH, no need to RFC this.
If someone wants to object they can object to a PATCH.
