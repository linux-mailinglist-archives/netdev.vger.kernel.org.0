Return-Path: <netdev+bounces-1174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D8E36FC804
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 538EF1C20B7E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D6C182CF;
	Tue,  9 May 2023 13:36:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B92CAD29
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:36:34 +0000 (UTC)
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195F8E61
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:36:22 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 5F9D63000452C;
	Tue,  9 May 2023 15:36:20 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 53526184F9D; Tue,  9 May 2023 15:36:20 +0200 (CEST)
Date: Tue, 9 May 2023 15:36:20 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Philipp Rosenberger <p.rosenberger@kunbus.com>,
	Zhi Han <hanzhi09@gmail.com>
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead
 of workqueue
Message-ID: <20230509133620.GA14772@wunner.de>
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
 <20230509080627.GF38143@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230509080627.GF38143@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 11:06:27AM +0300, Leon Romanovsky wrote:
> On Tue, May 09, 2023 at 06:28:56AM +0200, Lukas Wunner wrote:
> > From: Philipp Rosenberger <p.rosenberger@kunbus.com>
> > 
> > The Microchip ENC28J60 SPI Ethernet driver schedules a work item from
> > the interrupt handler because accesses to the SPI bus may sleep.
> > 
> > On PREEMPT_RT (which forces interrupt handling into threads) this
> > old-fashioned approach unnecessarily increases latency because an
> > interrupt results in first waking the interrupt thread, then scheduling
> > the work item.  So, a double indirection to handle an interrupt.
> > 
> > Avoid by converting the driver to modern threaded interrupt handling.
> > 
> > Signed-off-by: Philipp Rosenberger <p.rosenberger@kunbus.com>
> > Signed-off-by: Zhi Han <hanzhi09@gmail.com>
> > [lukas: rewrite commit message, linewrap request_threaded_irq() call]
> 
> This is part of changelog which doesn't belong to commit message. The
> examples which you can find in git log, for such format like you used,
> are usually reserved to maintainers when they apply the patch.

Is that a new rule?

Honestly I think it's important to mention changes applied to
someone else's patch, if only to let it be known who's to blame
for any mistakes.

I'm seeing plenty of recent precedent in the git history where
non-committers fixed up patches and made their changes known in
this way, e.g.:

commit 99669259f3361d759219811e670b7e0742668556
Author:     Maxime Bizon <mbizon@freebox.fr>
AuthorDate: Thu Mar 16 16:33:16 2023 -0700
Commit:     David S. Miller <davem@davemloft.net>
CommitDate: Sun Mar 19 10:48:35 2023 +0000

    [florian: fix kdoc, added Fixes tag]
    Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 0c9ef08a4d0fd6c5e6000597b506235d71a85a61
Author:     Nathan Huckleberry <nhuck@google.com>
AuthorDate: Tue Nov 8 17:26:30 2022 -0700
Commit:     Paolo Abeni <pabeni@redhat.com>
CommitDate: Thu Nov 10 12:28:30 2022 +0100

    [nathan: Rebase on net-next and resolve conflicts
             Add note about new clang warning]
    Signed-off-by: Nathan Chancellor <nathan@kernel.org>
    Signed-off-by: Paolo Abeni <pabeni@redhat.com>

commit 91e87045a5ef6f7003e9a2cb7dfa435b9b002dbe
Author:     Steffen Bätz <steffen@innosonix.de>
AuthorDate: Fri Oct 28 13:31:58 2022 -0300
Commit:     Jakub Kicinski <kuba@kernel.org>
CommitDate: Mon Oct 31 20:00:20 2022 -0700

    [fabio: Improved commit log and extended it to mv88e6321_ops]
    Signed-off-by: Fabio Estevam <festevam@denx.de>
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>

commit ebe73a284f4de8c5d401adeccd9b8fe3183b6e95
Author:     David Ahern <dsahern@kernel.org>
AuthorDate: Tue Jul 12 21:52:30 2022 +0100
Commit:     Jakub Kicinski <kuba@kernel.org>
CommitDate: Tue Jul 19 14:20:54 2022 -0700

    [pavel: move callback into msghdr]
    Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks,

Lukas

