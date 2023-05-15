Return-Path: <netdev+bounces-2616-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E972702B76
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3C7D1C20B37
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06742C138;
	Mon, 15 May 2023 11:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2C4C2DD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 11:27:14 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A319172B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 04:27:11 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Mon, 15 May 2023 13:27:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1684150024; bh=bcONLAH6knXEHrJvGB7J70yRBg1clKW8Wz9ykyvwfy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oK3ZKzYcmUluEMqNNca2Kz/Ij2k2eig4BbmFqsmj+13HW3/R97ahsKogkAmpLDz3n
	 AcM4x4WRdHofipIAN/j2LwMEamGTDiMC24lOotXmEVChJ1fkJ4J9SgqgylFGYE6F6l
	 LJlbkZLSDogGewrnt0mlQGufbLecprRxc1i8tK90=
Received: from localhost (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPSA id D5C1382176;
	Mon, 15 May 2023 13:27:03 +0200 (CEST)
Date: Mon, 15 May 2023 13:27:03 +0200
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 2/2] bridge: Add a sysctl to limit new brides
 FDB entries
Message-ID: <ZGIXB2DYA4sal9eW@u-jnixdorf.ads.avm.de>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <20230515085046.4457-2-jnixdorf-oss@avm.de>
 <dc8dfe0b-cf22-c4f9-8532-87643a6a9ceb@blackwall.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc8dfe0b-cf22-c4f9-8532-87643a6a9ceb@blackwall.org>
X-purgate-ID: 149429::1684150024-E743984B-2F0A3B9E/0/0
X-purgate-type: clean
X-purgate-size: 1831
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 12:35:47PM +0300, Nikolay Aleksandrov wrote:
> On 15/05/2023 11:50, Johannes Nixdorf wrote:
> > This is a convenience setting, which allows the administrator to limit
> > the default limit of FDB entries for all created bridges, instead of
> > having to set it for each created bridge using the netlink property.
> > 
> > The setting is network namespace local, and defaults to 0, which means
> > unlimited, for backwards compatibility reasons.
> > 
> > Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> > ---
> >  net/bridge/br.c         | 83 +++++++++++++++++++++++++++++++++++++++++
> >  net/bridge/br_device.c  |  4 +-
> >  net/bridge/br_private.h |  9 +++++
> >  3 files changed, 95 insertions(+), 1 deletion(-)
> > 
> 
> The bridge doesn't need private sysctls. Netlink is enough.
> Nacked-by: Nikolay Aleksandrov <razor@blackwall.org>

Fair enough.

I originally included the setting so there is a global setting an
administrator could toggle instead of having to hunt down each process
that might create a bridge, and teaching them to create them with an
FDB limit.

Does any of the following alternatives sound acceptable to you?:
 - Having the default limit (instead of the proposed default to unlimited)
   configurable in Kbuild. This would solve our problem, as we build
   our kernels ourselves, but I don't know whether putting a limit there
   would be acceptable for e.g. distributions.
 - Hardcoding a default limit != 0. I was afraid I'd break someones
   use-case with far too large bridged networks if I don't default to
   unlimited, but if you maintainers have a number in mind with which
   you don't see a problem, I'd be fine with it as well.

(Sorry for sending this mail twice, I accidentally dropped the list and
CC on the fist try)

