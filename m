Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF96D9C91
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbjDFPmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDFPmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:42:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CC212E;
        Thu,  6 Apr 2023 08:42:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E5264969;
        Thu,  6 Apr 2023 15:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4438C433EF;
        Thu,  6 Apr 2023 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680795739;
        bh=0rP+btQt9/KN1Mx9paUelvp606aFxYbSoZghoDoq1H4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AnKzCJXZBQ+rUdAxMp1hybL8+phnHiu+OVmBUUCFnjaaFhe3+JBjd9o4VRS+GFJN5
         0ly1kVhxI2roMjWYQf2+y5dMUvv1Ci2GTB8X6niozwhaxs1fWG7/KuVTMCenbUs5xJ
         R8hXBtyUSFnoU+CNCYwYm25JwnlAIBSzxJdnDB+2hCq3SOx7fwcXDY8zsCk14N9qoq
         cO6tIQNLWF5gMXxvCymTVgRxpzqnxdep0YsXGAt8iSW0KNea1/dVI1nKiiV2A6tVBN
         xZtV/Jig2E6z6EErWTaAiJWQujsjky70lsqYCoWXhW8RYF7/gAmGPfUx9p2iEz7+sS
         fW0nGSTlmCNtg==
Date:   Thu, 6 Apr 2023 08:42:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
Message-ID: <20230406084217.44fff254@kernel.org>
In-Reply-To: <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
        <20230404145131.GB3896@maniforge>
        <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
        <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
        <20230404185147.17bf217a@kernel.org>
        <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
        <20230405111926.7930dbcc@kernel.org>
        <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 22:13:26 -0700 Alexei Starovoitov wrote:
> On Wed, Apr 5, 2023 at 11:19=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> =
wrote:
> >
> > On Wed, 5 Apr 2023 10:22:16 -0700 Andrii Nakryiko wrote: =20
> > > So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
> > > everything locally. =20
> >
> > I think you can throw -M after -c $url? It can only help... :) =20
>=20
> Yeah. If only...
> I'm exclusively using -c.
> -M only works with -s, but I couldn't make -s -M work either.
> Do you pass the series as a number?

Yes, it copy just the numerical ID into the terminal.

> but then series_json=3D$(curl -s $srv/series/$1/) line
> doesn't look right, since it's missing "/mbox/" ?

That's loading JSON from the patchwork's REST API.

> User error on my side, I guess.
> My bash skills were too weak to make -c and -M work,
> but .git/hooks tip is great!
> Thank you.

FWIW I think the below may work for using -c instead of -s.
But it is mixing "Daniel paths" and "Jakub paths" in the script.
The output is still a bit different than when using -s.

diff --git a/pw-apply b/pw-apply
index 5fc37a24b027..c9cec94a4a8c 100755
--- a/pw-apply
+++ b/pw-apply
@@ -81,17 +81,15 @@ accept_series()
 }
=20
 cover_from_url()
 {
   curl -s $1 | gunzip -f -c > tmp.i
-  series_num=3D`grep "href=3D\"/series" tmp.i|cut -d/ -f3|head -1`
+  series=3D`grep "href=3D\"/series" tmp.i|cut -d/ -f3|head -1`
   cover_url=3D`grep "href=3D\"/project/netdevbpf/cover" tmp.i|cut -d\" -f2`
   if [ ! -z "$cover_url" ]; then
-    curl -s https://patchwork.kernel.org${cover_url}mbox/ | gunzip -f -c >=
 cover.i
     merge=3D"1"
   fi
-  curl -s https://patchwork.kernel.org/series/$series_num/mbox/ | gunzip -=
f -c > mbox.i
 }
=20
 edits=3D""
 am_flags=3D""
 branch=3D"mbox"
@@ -118,18 +116,20 @@ while true; do
     -h | --help ) usage; break ;;
     -- ) shift; break ;;
     * )  break ;;
   esac
 done
+# Load the info from cover first, it may will populate $series and $merge
+[ ! -z "$cover" ]  && cover_from_url $cover
+
 [ ! -z "$auto_branch" ] && [ -z "$series" ] && usage
 [ ! -z "$mbox" ]   && [ ! -z "$series" ] && usage
 [   -z "$mbox" ]   && [   -z "$series" ] && [ -z "$cover" ] && usage
 [ ! -z "$accept" ] && [ ! -z "$mbox" ]   && usage
 [ ! -z "$series" ] && mbox_from_series $series
 [ ! -z "$mbox" ]   && mbox_from_url $mbox
 [ ! -z "$accept" ] && accept_series $series
-[ ! -z "$cover" ]  && cover_from_url $cover
=20
 target=3D$(git branch --show-current)
=20
 body=3D
 author=3DXYZ
