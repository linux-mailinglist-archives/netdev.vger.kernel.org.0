Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C05375CDA
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhEFVcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhEFVcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 17:32:02 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D0C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 14:31:02 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t2-20020a17090a0242b0290155433387beso3503490pje.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 14:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oi0cbQgZBeAaMyDsOGCoO5zmgMdqr13FVdu0cslMJoo=;
        b=q92HRA5fnJS5ovtTq5u3B+idyfSj1tx1ycmExaqbnNZsZdQzOUb34x73o6TMzfOvvA
         ZTzMCKx3ud4Jv7KkjMefcAtqxTKckJ6ODPngPV6HZV6qeE/5uYQi9KwSndZSOD6649Pw
         tT8UUTKRzb/WpBmzaHIXyYxPil1ROXsEhl5Kq+OeVl5jN63Gs+Iv71jrfrPuz+Tv8769
         06R3IpXuoJ6RV2C5F5DdA6R35YH8dJQvs3B0guJTKnfLHsWgxmbzMyg/3fHUd5+Gz5dw
         z7aM7JEtgOfdKO6smhYkQUsBUog82njHzcGtybKbKF9WDjQQVqtTqCNJWaHdq0cob15A
         sp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oi0cbQgZBeAaMyDsOGCoO5zmgMdqr13FVdu0cslMJoo=;
        b=FSRhoZT3Mel+6Sgps1ci2yOexSKzRg6QfqyqE4HrdaVdV6ggEW5pZTKHmjcOvRtlYO
         SMWaDayu+KpgtKGZSt6qix4S5MDGDdaTrCdOTC5cRXcbleAoOJhy8wx6Ok4AubkFNlRV
         6ol0dTRQ1mecAB07qIQWs68A0rts8hDzGp2wdm9y5fmzsmTuX0ZQgD13j9b56VXECJOk
         n5YAPD0mxBzOe/t9vBgU1K8b0pU4Rd3SvO/1KLWeggy6FqBCvYbdMUTXcOVp4SH/Ys0x
         7aPyHzKa6gajczRGGPPqKZsTeMCsPYTw6TLgTabHQSu8V+w/oNC2OBwz182jOSbjbIpi
         S+/Q==
X-Gm-Message-State: AOAM530BD8/dLBmInI0xxiwjSuRa9QGhkvIeLZAT2wmTzHo8BauEMhf7
        R3L/D5vXf2Hmo/ZLA9JwQZRC2BeV4ueWYzMAO6k=
X-Google-Smtp-Source: ABdhPJx1onXeA5lLqu0EEqJoSzsewWkaS+RNRx4eFoJQYJcFkeGF1dc0xHCCrxny5oFyImg4dWbBYu4ZWqUt6IIRqbs=
X-Received: by 2002:a17:902:d386:b029:ee:bf5f:c037 with SMTP id
 e6-20020a170902d386b02900eebf5fc037mr6490522pld.31.1620336662190; Thu, 06 May
 2021 14:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210505233642.13661-1-xiyou.wangcong@gmail.com> <d7581cb6-a795-42a3-346a-07ccfa8fc8ce@gmail.com>
In-Reply-To: <d7581cb6-a795-42a3-346a-07ccfa8fc8ce@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 6 May 2021 14:30:51 -0700
Message-ID: <CAM_iQpX9N5UswtQPAe__baUm4hU3vKZ5tQFyAE61qHAQSfcbWQ@mail.gmail.com>
Subject: Re: [Patch net] rtnetlink: use rwsem to protect rtnl_af_ops list
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com>
Content-Type: multipart/mixed; boundary="0000000000002ae66c05c1b0073d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002ae66c05c1b0073d
Content-Type: text/plain; charset="UTF-8"

On Thu, May 6, 2021 at 5:26 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On 5/6/21 8:36 AM, Cong Wang wrote:
>  > From: Cong Wang <cong.wang@bytedance.com>
>  >
>
> Hi Cong,
> Thank you so much for fixing it!
>
>  > We use RTNL lock and RCU read lock to protect the global
>  > list rtnl_af_ops, however, this forces the af_ops readers
>  > being in atomic context while iterating this list,
>  > particularly af_ops->set_link_af(). This was not a problem
>  > until we begin to take mutex lock down the path in
>  > __ipv6_dev_mc_dec().
>  >
>  > Convert RTNL+RCU to rwsemaphore, so that we can block on
>  > the reader side while still allowing parallel readers.
>  >
>  > Reported-and-tested-by:
> syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
>  > Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface
> mld data")
>  > Cc: Taehee Yoo <ap420073@gmail.com>
>  > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>
> I have been testing this patch and I found a warning

Ah, good catch! I clearly missed that code path.

Can you help test the attached patch? syzbot is happy with it at least,
my CI bot is down so I can't run selftests for now.

Thanks.

--0000000000002ae66c05c1b0073d
Content-Type: text/x-patch; charset="US-ASCII"; name="rtnetlink.diff"
Content-Disposition: attachment; filename="rtnetlink.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kodeljbw0>
X-Attachment-Id: f_kodeljbw0

Y29tbWl0IDJlNWE5M2NiNjFkNzE2NzI1NTAxZDNhNDk5OWFiY2M5MjA3ZGUzYTUKQXV0aG9yOiBD
b25nIFdhbmcgPGNvbmcud2FuZ0BieXRlZGFuY2UuY29tPgpEYXRlOiAgIFRodSBNYXkgNiAxMjoz
ODo1MyAyMDIxIC0wNzAwCgogICAgcnRuZXRsaW5rOiBhdm9pZCBSQ1UgcmVhZCBsb2NrIHdoZW4g
aG9sZGluZyBSVE5MCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IENvbmcgV2FuZyA8Y29uZy53YW5n
QGJ5dGVkYW5jZS5jb20+CgpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvcnRuZXRsaW5rLmMgYi9uZXQv
Y29yZS9ydG5ldGxpbmsuYwppbmRleCA3MTRkNWZhMzg1NDYuLjA0YjRmMGYyYTNkMiAxMDA2NDQK
LS0tIGEvbmV0L2NvcmUvcnRuZXRsaW5rLmMKKysrIGIvbmV0L2NvcmUvcnRuZXRsaW5rLmMKQEAg
LTU0Myw3ICs1NDMsOSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHJ0bmxfYWZfb3BzICpydG5sX2Fm
X2xvb2t1cChjb25zdCBpbnQgZmFtaWx5KQogewogCWNvbnN0IHN0cnVjdCBydG5sX2FmX29wcyAq
b3BzOwogCi0JbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3Uob3BzLCAmcnRubF9hZl9vcHMsIGxpc3Qp
IHsKKwlBU1NFUlRfUlROTCgpOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShvcHMsICZydG5sX2Fm
X29wcywgbGlzdCkgewogCQlpZiAob3BzLT5mYW1pbHkgPT0gZmFtaWx5KQogCQkJcmV0dXJuIG9w
czsKIAl9CkBAIC0yMjc0LDI3ICsyMjc2LDE4IEBAIHN0YXRpYyBpbnQgdmFsaWRhdGVfbGlua21z
ZyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgbmxhdHRyICp0YltdKQogCQlubGFfZm9y
X2VhY2hfbmVzdGVkKGFmLCB0YltJRkxBX0FGX1NQRUNdLCByZW0pIHsKIAkJCWNvbnN0IHN0cnVj
dCBydG5sX2FmX29wcyAqYWZfb3BzOwogCi0JCQlyY3VfcmVhZF9sb2NrKCk7CiAJCQlhZl9vcHMg
PSBydG5sX2FmX2xvb2t1cChubGFfdHlwZShhZikpOwotCQkJaWYgKCFhZl9vcHMpIHsKLQkJCQly
Y3VfcmVhZF91bmxvY2soKTsKKwkJCWlmICghYWZfb3BzKQogCQkJCXJldHVybiAtRUFGTk9TVVBQ
T1JUOwotCQkJfQogCi0JCQlpZiAoIWFmX29wcy0+c2V0X2xpbmtfYWYpIHsKLQkJCQlyY3VfcmVh
ZF91bmxvY2soKTsKKwkJCWlmICghYWZfb3BzLT5zZXRfbGlua19hZikKIAkJCQlyZXR1cm4gLUVP
UE5PVFNVUFA7Ci0JCQl9CiAKIAkJCWlmIChhZl9vcHMtPnZhbGlkYXRlX2xpbmtfYWYpIHsKIAkJ
CQllcnIgPSBhZl9vcHMtPnZhbGlkYXRlX2xpbmtfYWYoZGV2LCBhZik7Ci0JCQkJaWYgKGVyciA8
IDApIHsKLQkJCQkJcmN1X3JlYWRfdW5sb2NrKCk7CisJCQkJaWYgKGVyciA8IDApCiAJCQkJCXJl
dHVybiBlcnI7Ci0JCQkJfQogCQkJfQotCi0JCQlyY3VfcmVhZF91bmxvY2soKTsKIAkJfQogCX0K
IApAQCAtMjg2OCwxNyArMjg2MSwxMiBAQCBzdGF0aWMgaW50IGRvX3NldGxpbmsoY29uc3Qgc3Ry
dWN0IHNrX2J1ZmYgKnNrYiwKIAkJbmxhX2Zvcl9lYWNoX25lc3RlZChhZiwgdGJbSUZMQV9BRl9T
UEVDXSwgcmVtKSB7CiAJCQljb25zdCBzdHJ1Y3QgcnRubF9hZl9vcHMgKmFmX29wczsKIAotCQkJ
cmN1X3JlYWRfbG9jaygpOwotCiAJCQlCVUdfT04oIShhZl9vcHMgPSBydG5sX2FmX2xvb2t1cChu
bGFfdHlwZShhZikpKSk7CiAKIAkJCWVyciA9IGFmX29wcy0+c2V0X2xpbmtfYWYoZGV2LCBhZiwg
ZXh0YWNrKTsKLQkJCWlmIChlcnIgPCAwKSB7Ci0JCQkJcmN1X3JlYWRfdW5sb2NrKCk7CisJCQlp
ZiAoZXJyIDwgMCkKIAkJCQlnb3RvIGVycm91dDsKLQkJCX0KIAotCQkJcmN1X3JlYWRfdW5sb2Nr
KCk7CiAJCQlzdGF0dXMgfD0gRE9fU0VUTElOS19OT1RJRlk7CiAJCX0KIAl9CmRpZmYgLS1naXQg
YS9uZXQvaXB2NC9kZXZpbmV0LmMgYi9uZXQvaXB2NC9kZXZpbmV0LmMKaW5kZXggMmUzNWY2OGRh
NDBhLi41MGRlZWZmNDhjOGIgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L2RldmluZXQuYworKysgYi9u
ZXQvaXB2NC9kZXZpbmV0LmMKQEAgLTE5NTUsNyArMTk1NSw3IEBAIHN0YXRpYyBpbnQgaW5ldF92
YWxpZGF0ZV9saW5rX2FmKGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsCiAJc3RydWN0IG5s
YXR0ciAqYSwgKnRiW0lGTEFfSU5FVF9NQVgrMV07CiAJaW50IGVyciwgcmVtOwogCi0JaWYgKGRl
diAmJiAhX19pbl9kZXZfZ2V0X3JjdShkZXYpKQorCWlmIChkZXYgJiYgIV9faW5fZGV2X2dldF9y
dG5sKGRldikpCiAJCXJldHVybiAtRUFGTk9TVVBQT1JUOwogCiAJZXJyID0gbmxhX3BhcnNlX25l
c3RlZF9kZXByZWNhdGVkKHRiLCBJRkxBX0lORVRfTUFYLCBubGEsCkBAIC0xOTgxLDcgKzE5ODEs
NyBAQCBzdGF0aWMgaW50IGluZXRfdmFsaWRhdGVfbGlua19hZihjb25zdCBzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LAogc3RhdGljIGludCBpbmV0X3NldF9saW5rX2FmKHN0cnVjdCBuZXRfZGV2aWNl
ICpkZXYsIGNvbnN0IHN0cnVjdCBubGF0dHIgKm5sYSwKIAkJCSAgICBzdHJ1Y3QgbmV0bGlua19l
eHRfYWNrICpleHRhY2spCiB7Ci0Jc3RydWN0IGluX2RldmljZSAqaW5fZGV2ID0gX19pbl9kZXZf
Z2V0X3JjdShkZXYpOworCXN0cnVjdCBpbl9kZXZpY2UgKmluX2RldiA9IF9faW5fZGV2X2dldF9y
dG5sKGRldik7CiAJc3RydWN0IG5sYXR0ciAqYSwgKnRiW0lGTEFfSU5FVF9NQVgrMV07CiAJaW50
IHJlbTsKIAo=
--0000000000002ae66c05c1b0073d--
