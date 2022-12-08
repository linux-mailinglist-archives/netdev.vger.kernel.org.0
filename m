Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A44B647794
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiLHU6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLHU5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:57:38 -0500
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855761010;
        Thu,  8 Dec 2022 12:57:33 -0800 (PST)
Date:   Thu, 08 Dec 2022 20:57:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=n8pjl.ca;
        s=protonmail; t=1670533050; x=1670792250;
        bh=hiaxku4ECTjcW+ViXhS5y1VGBf4iN9SgQmqH7d1kyhg=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=ALdD6BUkF8H4ruV1Xbkf6pVWLASu45arsqZf/Hs1yj+Tk4fA+GTfcqjFNGA76RpjF
         wYOQyQlIC+aeDeROr5fpPbLcH2yLaFieVaNVXEyPP9Gy7EngIcOhxR0wHrkAQKAAaQ
         Qg09qRacM/v9pwWjTLTIsLV6ZbHdEQqCWvLtGcp+0WxJds0aWLEcH9vq0f4f/9R1WK
         Y2ZKyexYY2hPO20R+MlImihMxQEq3bglUdUCKVRWc7+KRJTk5+Ff1l3q7JhKBOtsda
         ZmhYh5T75Ooao1I9+aaD5VrDyjbyZPDaFOKNathPvad+Jc5VzTRdsaCXEzLLBj0iwZ
         n03z6rvxRo3HA==
To:     Yury Norov <yury.norov@gmail.com>
From:   Peter Lafreniere <peter@n8pjl.ca>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 5/5] lib/cpumask: reorganize cpumask_local_spread() logic
Message-ID: <tWPflu4f2FG07nbY54Gbs5fkI1u8Fjc0dLg60fY6deUx8p4jpZmOpOLr_ffvJz_EYWZDNiVLFHlzwMwMMFqWlF8NwXa0XZqlUWbgXE7zgFQ=@n8pjl.ca>
In-Reply-To: <Y5JL/YqlxoC/4j4A@yury-laptop>
References: <20221208183101.1162006-1-yury.norov@gmail.com> <20221208183101.1162006-6-yury.norov@gmail.com> <KQCC2QYXZ6BtFjiUQO-XQNUO5Ub3kGfpKzjfIeUfCQEvMUEMKiZ7ofEMqoZElMYxYFtuRqW6v3UzCpDzDR-QYZk-tpMDVLl_HSl8BEi1hZk=@n8pjl.ca> <Y5JL/YqlxoC/4j4A@yury-laptop>
Feedback-ID: 53133685:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Dec 08, 2022 at 08:17:22PM +0000, Peter Lafreniere wrote:
> > > Now after moving all NUMA logic into sched_numa_find_nth_cpu(),
> > > else-branch of cpumask_local_spread() is just a function call, and
> > > we can simplify logic by using ternary operator.
> > >
> > > While here, replace BUG() with WARN().
> > Why make this change? It's still as bad to hit the WARN_ON as it was be=
fore.
>
> For example, because of this:
>
>  > Greg, please don't do this
>  >
>  > > ChangeSet@1.614, 2002-09-05 08:33:20-07:00, greg@kroah.com
>  > >   USB: storage driver: replace show_trace() with BUG()
>  >
>  > that BUG() thing is _way_ out of line, and has killed a few of my mach=
ines
>  > several times for no good reason. It actively hurts debuggability, bec=
ause
>  > the machine is totally dead after it, and the whole and ONLY point of
>  > BUG() messages is to help debugging and make it clear that we can't ha=
ndle
>  > something.
>  >
>  > In this case, we _can_ handle it, and we're much better off with a mac=
hine
>  > that works and that you can look up the messages with than killing it.
>  >
>  > Rule of thumb: BUG() is only good for something that never happens and
>  > that we really have no other option for (ie state is so corrupt that
>  > continuing is deadly).
>  >
>  >            Linus

Fair enough. It's not like it'll be hit anyway. My concern was for if
any of the 23 callers get an invalid result. I guess that if that causes
a crash, then so be it. We have the warning to track down the cause.

Thanks for the explanation,
Peter Lafreniere <peter@n8pjl.ca>
