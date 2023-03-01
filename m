Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70D66A6D63
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 14:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjCANub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 08:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCANua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 08:50:30 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F79D27D75
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 05:50:27 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id nv15so9219329qvb.7
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 05:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677678626;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5v2Jj/5H4WZ6z7e/ptSvRmwSxMTQqIM+y4Y/N9p8yh0=;
        b=hG2ZfxzPWV/dBUfhfxER07sWC+KZYlVf/i3B+8rnZrsFGiwik9lHPyefIKdKS5x47z
         7dHBu/25kdygXaT/8XTYKIofnA9B2rHfcDVkOgMTQ/jIaf+nvpG9oriHZmTDuTCss8e9
         xxbojIFaMN/t/VloUFo8Evf9U6eKZ5UPhgH+GikXayI50/VLRyv6psL963d2ntRiFLlS
         YXDquMhN+9cemYlWv9VztkCi4SFE6x+a3rMHmmEBjKVDP/D9C+SfeFSf1IYBNkXJvhmy
         3+bnjidjLTc3ojGEV7Nu4gZ1clyglq66YFFf9Nuf/VXhHM+UzBAgPWPdwxtaYTzbmqYe
         TvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677678626;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5v2Jj/5H4WZ6z7e/ptSvRmwSxMTQqIM+y4Y/N9p8yh0=;
        b=ifkd2MQmcOYO0rYKH9UIs9V26qMk4oo0hdfcOYb8MK4ZE/JHociHVeEvZc99rHNcqZ
         6aoDiAvqU9RTWXdN5qsaeBQLEOL1qHuFqEBswe1QsxP6BjJRY+P/eq++U5F/ITAerYwc
         vx2T4Agr9YOYXXz6SeD+/GKKtnHpdJvreYJWQwn9QeW/bJjOoR6Z7/An1nzd43ClesHn
         bXOdxq4wDjOh6BMQ2I7jz2yk0NMavqsJQBlprjqngP4a4uDe5GE4gnLKktN/rXehhrSu
         p1RIo2NZIj385uiWIex2FJiL4jofHiP28qvoTqSiduu6s5hDU9QmZEaF4CkR17o3cJjd
         m2wQ==
X-Gm-Message-State: AO0yUKVGEPdv5EXa4cU5uSwx5utMe2+WvJqaUm3IEEg+4bhTkM7ZmaEM
        BUT/P794/StE/3TH6a687htaVnIlwJDIaBTT73Trl3xITOUVJk34
X-Google-Smtp-Source: AK7set++6oSvJ5bD4Fsqp4KTRvplZoCtBQIlM4eLV44ZTqO3VJTSfPacF/wrM4pky///oj0wbZaF3TsR1peGqHYmcSk=
X-Received: by 2002:a05:6214:8f1:b0:56e:f4f0:e71d with SMTP id
 dr17-20020a05621408f100b0056ef4f0e71dmr1772243qvb.6.1677678626173; Wed, 01
 Mar 2023 05:50:26 -0800 (PST)
MIME-Version: 1.0
From:   ismail bouzaiene <ismailbouzaiene@gmail.com>
Date:   Wed, 1 Mar 2023 14:50:15 +0100
Message-ID: <CAPagGtuJQO5dj=qd96kWFWLfcX8Pt0m9B9J8xiFGPNUfEnPLkA@mail.gmail.com>
Subject: [PATCH] net : fix adding same ip rule multiple times
To:     netdev@vger.kernel.org, davem@davemloft.net,
        "edumazet@google.com" <edumazet@google.com>, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: multipart/mixed; boundary="000000000000900c7a05f5d6feab"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000900c7a05f5d6feab
Content-Type: text/plain; charset="UTF-8"

Hello,

In case we try to add the same ip rule multiple times, the kernel will
reject the addition using the call rule_exits().

However there are two use cases where it is still possible to add the
same ip rule multiple times despite the check rule_exists().

First use case :

add two ip rules with the same informations and only the prio / pref
attribute is different

Second use case :

add two ip rules with the same informations without setting the
attribute prio / pref
In this case, the kernel will attribute a pref to this ip rule using
the following mechanism :

Kernel will loop over all already applied ip rules, get the index of
the first ip rule with pref not null
add +1 and use this value to set the pref field in the ip rule to be applied.


The two use cases are possible because the call rule_exists() checks
the prio / pref among others parameters, and in both cases the prio /
pref attribute will be different from any of the already applied ip
rules.

I suggest fixing the mentioned two cases by removing the test on the
pref / prio attribute in the function rule_exits().

This patch implement the suggested solution : patch_solAllcases.patch

In case you think that the First use case is a valid use case and we
need only to handle the Second use case, I provide here also a second
patch that handle only the First use case :

patch_solOnlySecondCase.patch

--000000000000900c7a05f5d6feab
Content-Type: text/x-patch; charset="US-ASCII"; name="patch_solAllcases.patch"
Content-Disposition: attachment; filename="patch_solAllcases.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lepqixrb0>
X-Attachment-Id: f_lepqixrb0

ZGlmZiAtdXByTiBuZXQtbmV4dC02LjItcmM3L25ldC9jb3JlL2ZpYl9ydWxlcy5jIG5ldC1uZXh0
LTYuMi1yYzdfcGF0Y2gtU29sMS9uZXQvY29yZS9maWJfcnVsZXMuYwotLS0gbmV0LW5leHQtNi4y
LXJjNy9uZXQvY29yZS9maWJfcnVsZXMuYwkyMDIzLTAyLTA1IDIyOjEzOjI4LjAwMDAwMDAwMCAr
MDEwMAorKysgbmV0LW5leHQtNi4yLXJjN19wYXRjaC1Tb2wxL25ldC9jb3JlL2ZpYl9ydWxlcy5j
CTIwMjMtMDItMTcgMTA6Mjc6NTQuOTkyOTQ4MDA2ICswMTAwCkBAIC02OTUsOSArNjk1LDYgQEAg
c3RhdGljIGludCBydWxlX2V4aXN0cyhzdHJ1Y3QgZmliX3J1bGVzXwogCQlpZiAoci0+dGFibGUg
IT0gcnVsZS0+dGFibGUpCiAJCQljb250aW51ZTsKIAotCQlpZiAoci0+cHJlZiAhPSBydWxlLT5w
cmVmKQotCQkJY29udGludWU7Ci0KIAkJaWYgKG1lbWNtcChyLT5paWZuYW1lLCBydWxlLT5paWZu
YW1lLCBJRk5BTVNJWikpCiAJCQljb250aW51ZTsKIAo=
--000000000000900c7a05f5d6feab
Content-Type: text/x-patch; charset="US-ASCII"; name="patch_solOnlySecondCase.patch"
Content-Disposition: attachment; filename="patch_solOnlySecondCase.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lepqixrm1>
X-Attachment-Id: f_lepqixrm1

ZGlmZiAtdXByTiBuZXQtbmV4dC02LjItcmM3L25ldC9jb3JlL2ZpYl9ydWxlcy5jIG5ldC1uZXh0
LTYuMi1yYzdfcGF0Y2gtU29sMi9uZXQvY29yZS9maWJfcnVsZXMuYwotLS0gbmV0LW5leHQtNi4y
LXJjNy9uZXQvY29yZS9maWJfcnVsZXMuYwkyMDIzLTAyLTA1IDIyOjEzOjI4LjAwMDAwMDAwMCAr
MDEwMAorKysgbmV0LW5leHQtNi4yLXJjN19wYXRjaC1Tb2wyL25ldC9jb3JlL2ZpYl9ydWxlcy5j
CTIwMjMtMDItMTcgMTA6MDQ6MDEuMTExMjQyMjMwICswMTAwCkBAIC02ODQsNyArNjg0LDcgQEAg
ZXJyb3V0OgogfQogCiBzdGF0aWMgaW50IHJ1bGVfZXhpc3RzKHN0cnVjdCBmaWJfcnVsZXNfb3Bz
ICpvcHMsIHN0cnVjdCBmaWJfcnVsZV9oZHIgKmZyaCwKLQkJICAgICAgIHN0cnVjdCBubGF0dHIg
Kip0Yiwgc3RydWN0IGZpYl9ydWxlICpydWxlKQorCQkgICAgICAgc3RydWN0IG5sYXR0ciAqKnRi
LCBzdHJ1Y3QgZmliX3J1bGUgKnJ1bGUsYm9vbCB1c2VyX3ByaW9yaXR5KQogewogCXN0cnVjdCBm
aWJfcnVsZSAqcjsKIApAQCAtNjk1LDcgKzY5NSw3IEBAIHN0YXRpYyBpbnQgcnVsZV9leGlzdHMo
c3RydWN0IGZpYl9ydWxlc18KIAkJaWYgKHItPnRhYmxlICE9IHJ1bGUtPnRhYmxlKQogCQkJY29u
dGludWU7CiAKLQkJaWYgKHItPnByZWYgIT0gcnVsZS0+cHJlZikKKwkJaWYgKHVzZXJfcHJpb3Jp
dHkgJiYgci0+cHJlZiAhPSBydWxlLT5wcmVmKQogCQkJY29udGludWU7CiAKIAkJaWYgKG1lbWNt
cChyLT5paWZuYW1lLCBydWxlLT5paWZuYW1lLCBJRk5BTVNJWikpCkBAIC04MDYsNyArODA2LDcg
QEAgaW50IGZpYl9ubF9uZXdydWxlKHN0cnVjdCBza19idWZmICpza2IsCiAJCWdvdG8gZXJyb3V0
OwogCiAJaWYgKChubGgtPm5sbXNnX2ZsYWdzICYgTkxNX0ZfRVhDTCkgJiYKLQkgICAgcnVsZV9l
eGlzdHMob3BzLCBmcmgsIHRiLCBydWxlKSkgeworCSAgICBydWxlX2V4aXN0cyhvcHMsIGZyaCwg
dGIsIHJ1bGUsdXNlcl9wcmlvcml0eSkpIHsKIAkJZXJyID0gLUVFWElTVDsKIAkJZ290byBlcnJv
dXRfZnJlZTsKIAl9Cg==
--000000000000900c7a05f5d6feab--
