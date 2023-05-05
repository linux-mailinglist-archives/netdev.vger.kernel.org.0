Return-Path: <netdev+bounces-498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27F1D6F7D0F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEA3F280F51
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 06:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A3A1103;
	Fri,  5 May 2023 06:40:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CA6ED1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:40:35 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B6215EC7;
	Thu,  4 May 2023 23:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=X0c1PBLFOhai+mqhEBi/tW1OeYtirBEECbmlevNdTtM=;
	t=1683268834; x=1684478434; b=tYED6gMyFU8FHCp/t2Z6rOgjV0iHJl6LS3GH/R3WbiO4vZV
	Qj4cn5YUTsx/4o08IYEzd90oy6527pEyfaXDS5UlujiTe6R5rcWSzwW4Z/IYozCcNL1b0uKkwdomr
	FBN19mi5RqNndBQ0QHPZ2GRrQcvPlHe0/lxQj2UIutnub+3CPlgLCI9txyKjwI0ak7wGsstlH9MKU
	u4uegyw6u2uyhkBd5HhyBGG7VWVKD3DMb8O6J0Kk/UENTPLzsX/Z8KboshxtZzHozZ9RLRuS1uGJv
	QlpTxgPNdBhIx77QQLZQAzlxjerzjVuoOQ2tIugubMKOr+Qc1713nLkV4C2OFKAA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1pup74-000CRq-0E;
	Fri, 05 May 2023 08:40:18 +0200
Message-ID: <f02a94a6cad2e87e0cfe9c8ca8eedc89753313ab.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: Fix spurious packet drops with RSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: "Greenman, Gregory" <gregory.greenman@intel.com>, Kalle Valo
 <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, "Goodstein, Mordechay"
 <mordechay.goodstein@intel.com>,  "Coelho, Luciano"
 <luciano.coelho@intel.com>, "Sisodiya, Mukesh" <mukesh.sisodiya@intel.com>,
  "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 05 May 2023 08:40:16 +0200
In-Reply-To: <ZFPxkRKep27H74Su@sultan-box.localdomain>
References: <20230430001348.3552-1-sultan@kerneltoast.com>
	 <8d2b0aec270b8cd0111654dc4b361987a112d3ce.camel@sipsolutions.net>
	 <ZFPxkRKep27H74Su@sultan-box.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-04 at 10:55 -0700, Sultan Alsawaf wrote:
> >=20
> > So I assume you tested it now, and it works? Somehow I had been under
> > the impression we never got it to work back when...
>=20
> Yep, I've been using this for about a year and have let it run through th=
e
> original iperf3 reproducer I mentioned on bugzilla for hours with no stal=
ls. My
> big git clones don't freeze anymore either. :)

Oh! OK, great.

> What I wasn't able to get working was the big reorder buffer cleanup that=
's made
> possible by using these firmware bits. The explicit queue sync can be rem=
oved
> easily, but there were further potential cleanups you had mentioned that =
I
> wasn't able to get working.

Fair enough.

> I hadn't submitted this patch until now because I was hoping to get the b=
ig
> cleanup done simultaneously but I got too busy until now. Since this smal=
l patch
> does fix the issue, my thought is that this could be merged and sent to s=
table,
> and with subsequent patches I can chip away at cleaning up the reorder bu=
ffer.

Sure, that makes sense.

> > > Johannes mentions that the 9000 series' firmware doesn't support thes=
e
> > > bits, so disable RSS on the 9000 series chipsets since they lack a
> > > mechanism to properly detect old and duplicated frames.
> >=20
> > Indeed, I checked this again, I also somehow thought it was backported
> > to some versions but doesn't look like. We can either leave those old
> > ones broken (they only shipped with fewer cores anyway), or just disabl=
e
> > it as you did here, not sure. RSS is probably not as relevant with thos=
e
> > slower speeds anyway.
>=20
> Agreed, I think it's worth disabling RSS on 9000 series to fix it there. =
If the
> RX queues are heavily backed up and incoming packets are not released fas=
t
> enough due to a slow CPU, then I think the spurious drops could happen so=
mewhat
> regularly on slow devices using 9000 series.
>=20
> It's probably also difficult to judge the impact/frequency of these spuri=
ous
> drops in the wild due to TCP retries potentially masking them. The issue =
can be
> very noticeable when a lot of packets are spuriously dropped at once thou=
gh, so
> I think it's certainly worth the tradeoff to disable RSS on the older chi=
psets.

:)

> Indeed, and removing the queue sync + timer are easy. Would you prefer I =
send
> additional patches for at least those cleanups before the fix itself can =
be
> considered for merging?
>=20

No, you know, maybe this is easier since it's the smallest possible
change that fixes issues. Just have to see what Emmanuel says, he had
said he sees issues with this change.

johannes

