Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD536652540
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 18:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiLTRKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 12:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiLTRKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 12:10:44 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1266CBDB
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 09:10:43 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a14so8954098pfa.1
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 09:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o6/NwTvG1ts0rBmQ9K+XNWZapy07EBTMQ36kpdSkC/M=;
        b=SuEARZa3uOm8eCuCEdXiIA4dUUCYwaj39AXx4CUb7Emp5srU0IfqLWX6UpLoFkhSXZ
         4Mpvt6m02Lqbp9omusDqgAq5VhcKkgz7khoAAomedfqx1V48/bPStI1ncUcCylbg3I2B
         QvcwA7StM6sYXK6TQSvsS6bPctruF9XULezH8Lijef5n63XHHBDfj+IyhhnuHi8c11pG
         COmMgXNoS1H6eAQYcE3YfG8lCkOqNNS5AHqbwi37wmrPl82aRzed5fYoPwcrKAG/N8oy
         rfIY2P6TciwstqsQc+Ngkgjr0l5NSK64VOq0/LdvgV/kIm8z/2sbGCgsjdmP8Xyo6EqH
         nA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o6/NwTvG1ts0rBmQ9K+XNWZapy07EBTMQ36kpdSkC/M=;
        b=Zh97MzEahkm47MeiekbrtHDQiQfht6mVy07GPQm9WdRDOW4rFcVeJl/b4gPJDcGFiw
         rkTOaRN8tLlcCWZjIgi01pD9IhN2XtdgYkNbWyDLIbpzDGRDPGT29cIu70D9z7f+IOFq
         Y7sE7LQ5k/UXt7hs2cUGLdi90TIBQkJ6qvTdPLUG/X3gQNedSmgQw6CmtYbVs/navzEQ
         3vy0qG5c4HBy9FZh6bAnhyHoexhxfFPCwpfDQP6xpDnbY+nzozvrqKrlMMMxUGTLplYV
         8FIB7ghP5QHF24nZiHZ3nBCeisu2QABIxeHeOTVJWRXcU7PVg5rI6u4YKTrsIXYLEBtc
         bOnA==
X-Gm-Message-State: ANoB5pneo3bcrIivpGtpCqV62zWdVa+JpDhbJsPFnFgbj37KJutMvRs/
        eGDO1BQsuwno64U2Pu7A4jPNq34IysWS8YGISBYuLw==
X-Google-Smtp-Source: AA0mqf4ZwwT4lP5lED/bdOCSru0RBf/NPcsWF81/I6R8hZ5dZvndnY8Ixug9Xf50fLBW1lod+238c4F2sWPMYEy34po=
X-Received: by 2002:a63:2160:0:b0:46f:f26e:e8ba with SMTP id
 s32-20020a632160000000b0046ff26ee8bamr74067527pgm.250.1671556242235; Tue, 20
 Dec 2022 09:10:42 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a20a2e05f029c577@google.com> <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
 <Y6C8iQGENUk/XY/A@google.com> <Y6Fw1ymTcFrMR3Hl@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6Fw1ymTcFrMR3Hl@hirez.programming.kicks-ass.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 20 Dec 2022 09:10:30 -0800
Message-ID: <CAKH8qBs1UiikX=_CBzRC_2rg3sp8CU5hhB7sOkNkNBqm8OqFEw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>,
        acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="0000000000000ba28505f0458408"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000ba28505f0458408
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 20, 2022 at 12:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Dec 19, 2022 at 11:33:29AM -0800, sdf@google.com wrote:
> > On 12/19, Peter Zijlstra wrote:
> > > On Mon, Dec 19, 2022 at 12:04:43AM -0800, syzbot wrote:
>
> > > > HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of
> > > https://git.kernel...
> > > > git tree:       bpf
> > > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df7e0480000
> > > > kernel config:
> > > https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
> > > > dashboard link:
> > > https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
>
> ^ so syzbot knows what tree and config were used to trigger the report,
> then why:

I haven't used it before and wasn't sure whether it would take the
last commit from the branch of the one where it failed. Adding them
shouldn't hurt, right?

> > Let's maybe try it this way:
> >
> > #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> > 13e3c7793e2f
>
> do you have to repeat that again in order for it to test something?

Yeah, I was trying to understand why it doesn't like my patch. It
seems I can retry with the patch attached which hopefully should fix
the possible formatting issue; let's see.

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
13e3c7793e2f

--0000000000000ba28505f0458408
Content-Type: text/x-patch; charset="US-ASCII"; name="pmu.patch"
Content-Disposition: attachment; filename="pmu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lbwhemfp0>
X-Attachment-Id: f_lbwhemfp0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9ldmVudHMvY29yZS5jIGIva2VybmVsL2V2ZW50cy9jb3JlLmMK
aW5kZXggZTQ3OTE0YWM4NzMyLi5iYmZmNTUxNzgzZTEgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9ldmVu
dHMvY29yZS5jCisrKyBiL2tlcm5lbC9ldmVudHMvY29yZS5jCkBAIC0xMjY4OSw3ICsxMjY4OSw4
IEBAIFNZU0NBTExfREVGSU5FNShwZXJmX2V2ZW50X29wZW4sCiAJcmV0dXJuIGV2ZW50X2ZkOwog
CiBlcnJfY29udGV4dDoKLQkvKiBldmVudC0+cG11X2N0eCBmcmVlZCBieSBmcmVlX2V2ZW50KCkg
Ki8KKwlwdXRfcG11X2N0eChldmVudC0+cG11X2N0eCk7CisJZXZlbnQtPnBtdV9jdHggPSBOVUxM
OyAvKiBfZnJlZV9ldmVudCgpICovCiBlcnJfbG9ja2VkOgogCW11dGV4X3VubG9jaygmY3R4LT5t
dXRleCk7CiAJcGVyZl91bnBpbl9jb250ZXh0KGN0eCk7Cg==
--0000000000000ba28505f0458408--
