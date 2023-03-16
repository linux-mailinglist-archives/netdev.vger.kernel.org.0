Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ED16BC2DF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 01:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCPAgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 20:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCPAgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 20:36:11 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076E4911F3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:35:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id x3so1271142edb.10
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678926879;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c4ytvZFQnk2dd8yg7fmfdojrAwRoFMERsuXB5atfa10=;
        b=ISSzE3QoM1hdEvfpAJIGRQgWVvauHvA7riQxqjS0StYvcOcNg9SNqa5qk7B3d/z6Lb
         i9Ndl1Sbwoyri/cI4/kHT2e/isy30ZxozT+TJhZ6/Xxo76F76kG7rK3/btnj6D1a0Fma
         GK5PKY3OkCbBQ38zo9jMHL/r2PR7jENtNXmxk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678926879;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c4ytvZFQnk2dd8yg7fmfdojrAwRoFMERsuXB5atfa10=;
        b=4L+4idpVRozP/EE2whPj8mgJz8gSAzvhMykvoThBKtgsJRBHNvr1h4S4kJDAYzeB/p
         9/aS9dOe6Qch1Mm7x8UO/h0EFWQWdMviTBf3iqPBhp6ORgBzn752ioa5aCXPHroUZyKm
         Tb4EkEK+aiUUK925qMRYuleJOG9kqk1+QCntGdaDz0T3uaHAv3pdejCtN/CrAKfQtt2v
         UknUtty4zljTEeNm9UV/xp4JTLFOUoquSbX+KzUrXNq9+Mvhd+v6b2B1Dfl1iqyo41i5
         zIE90bG3jDrEo6TfVJa3R3iEwM9x/BuSxWEcBBy+f8H4/7U6ZNWUQgXJAgfirdN0cwzn
         CHrA==
X-Gm-Message-State: AO0yUKVwLJGMhUv6pUd0L9nvxgc5T1RZTmXZu0LRhNLKVF9soa8sPtvN
        kJcMegCxvxYt8pIXS9fRMuDoXNml6qrk+9yXAfepYA==
X-Google-Smtp-Source: AK7set/Uh/oRYvlQhT0FD9VQ4wlpbdBCHVVmTWSllKFcddXtbKKBYStbnpdPCfR7DG/bYQMY+JVDtw==
X-Received: by 2002:a17:906:6816:b0:930:1914:88fe with SMTP id k22-20020a170906681600b00930191488femr1098043ejr.68.1678926878885;
        Wed, 15 Mar 2023 17:34:38 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id m1-20020a50d7c1000000b004fc856b208asm3159584edj.51.2023.03.15.17.34.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:34:37 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id cn21so1542497edb.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 17:34:37 -0700 (PDT)
X-Received: by 2002:a17:906:1542:b0:8b1:28f6:8ab3 with SMTP id
 c2-20020a170906154200b008b128f68ab3mr4199462ejd.15.1678926877045; Wed, 15 Mar
 2023 17:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com> <20230315154245.3405750-2-edumazet@google.com>
 <20230315142841.3a2ac99a@kernel.org> <CANn89iLbOqjWVmgZKdGjbdsHw1EwO9d_w+dgKsyzLoq9pOsurQ@mail.gmail.com>
 <CAHk-=wiPUfe8aji5KojAhDKjWhJJU2F9kfzyL660=jRkY+Uzyg@mail.gmail.com>
 <CAHk-=wjgW-aFo3qLyssg+76-XkYbeMaH58FwW5Bd3-baqfXqrQ@mail.gmail.com>
 <CANn89i+DLp2tDG7DT1bdYvL1o0UBsBzGBA3t4J2P+yn_QLJX2Q@mail.gmail.com>
 <CAHk-=wiOf12nrYEF2vJMcucKjWPN-Ns_SW9fA7LwST_2Dzp7rw@mail.gmail.com>
 <CANn89iKiVQXC1briKcmKd2Fs77f+rBW_WuqCD9z_WViAWipzhg@mail.gmail.com>
 <CAHk-=wj+6FLCdOMR+NH=JsL2VccNJGhg1_3OKw+YOaP0+PxmZg@mail.gmail.com>
 <CANn89iKzNh0hvJNbKvo5tokg-Kf-btNYpMik8KQ53vLAWgrY9Q@mail.gmail.com> <CANn89i+uJwvGy6HRN4Ym8Q=jSDx=wDEU-5neo=b3C+xJf=pW-g@mail.gmail.com>
In-Reply-To: <CANn89i+uJwvGy6HRN4Ym8Q=jSDx=wDEU-5neo=b3C+xJf=pW-g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Mar 2023 17:34:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wijs3BOOnJ9chfhR9DEQ0LNL0krPfhi=d9_mUwSBhog1A@mail.gmail.com>
Message-ID: <CAHk-=wijs3BOOnJ9chfhR9DEQ0LNL0krPfhi=d9_mUwSBhog1A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] inet: preserve const qualifier in inet_sk()
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="0000000000001c92b805f6f9a057"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001c92b805f6f9a057
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 5:23=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> Oh I might have been fooled, because of course we can not use sk for
> the macro parameter name.

Heh. Yeah, that will rename the 'sk' member name too, and cause some
*very* strange errors.

> Basically something like this should work just fine

Yup.

I'm testing it on the current git tree, and I'm finding a number of
random issues, but it looks manageable. Attached is what I ended up
with.

You have presumably already fixed these issues in your tree.

Btw, it's very much things like 'tcp_sk()' too, and doing that with

   #define tcp_sk(ptr) container_of_const(ptr, struct tcp_sock,
inet_conn.icsk_inet.sk)

actually shows some fundamental problems. For example, we have
tcp_synq_overflow() that takes a const sk pointer, but then it does

        WRITE_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp, now);

which is a big no-no and writes to that sock thing.

I didn't even try any of the other 'xyzzy_sk()' conversions.

                   Linus

--0000000000001c92b805f6f9a057
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_lfadpayq0>
X-Attachment-Id: f_lfadpayq0

IGluY2x1ZGUvbGludXgvdGNwLmggICAgICAgICB8IDUgKy0tLS0KIGluY2x1ZGUvbmV0L2luZXRf
c29jay5oICAgICB8IDUgKy0tLS0KIGluY2x1ZGUvdHJhY2UvZXZlbnRzL3NvY2suaCB8IDQgKyst
LQogaW5jbHVkZS90cmFjZS9ldmVudHMvdGNwLmggIHwgMiArLQogbmV0L2lwdjQvaXBfb3V0cHV0
LmMgICAgICAgIHwgNCArKy0tCiBuZXQvbXB0Y3Avc29ja29wdC5jICAgICAgICAgfCAyICstCiBz
ZWN1cml0eS9sc21fYXVkaXQuYyAgICAgICAgfCA2ICsrKy0tLQogNyBmaWxlcyBjaGFuZ2VkLCAx
MSBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25l
dC9pbmV0X3NvY2suaCBiL2luY2x1ZGUvbmV0L2luZXRfc29jay5oCmluZGV4IDUxODU3MTE3YWMw
OS4uY2FhMjBhOTA1NTMxIDEwMDY0NAotLS0gYS9pbmNsdWRlL25ldC9pbmV0X3NvY2suaAorKysg
Yi9pbmNsdWRlL25ldC9pbmV0X3NvY2suaApAQCAtMzA1LDEwICszMDUsNyBAQCBzdGF0aWMgaW5s
aW5lIHN0cnVjdCBzb2NrICpza2JfdG9fZnVsbF9zayhjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2ti
KQogCXJldHVybiBza190b19mdWxsX3NrKHNrYi0+c2spOwogfQogCi1zdGF0aWMgaW5saW5lIHN0
cnVjdCBpbmV0X3NvY2sgKmluZXRfc2soY29uc3Qgc3RydWN0IHNvY2sgKnNrKQotewotCXJldHVy
biAoc3RydWN0IGluZXRfc29jayAqKXNrOwotfQorI2RlZmluZSBpbmV0X3NrKHB0cikgY29udGFp
bmVyX29mX2NvbnN0KHB0ciwgc3RydWN0IGluZXRfc29jaywgc2spCiAKIHN0YXRpYyBpbmxpbmUg
dm9pZCBfX2luZXRfc2tfY29weV9kZXNjZW5kYW50KHN0cnVjdCBzb2NrICpza190bywKIAkJCQkJ
ICAgICBjb25zdCBzdHJ1Y3Qgc29jayAqc2tfZnJvbSwKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJh
Y2UvZXZlbnRzL3NvY2suaCBiL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3NvY2suaAppbmRleCAwM2Qx
OWZjNTYyZjguLmZkMjA2YTZhYjViOCAxMDA2NDQKLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMv
c29jay5oCisrKyBiL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3NvY2suaApAQCAtMTU4LDcgKzE1OCw3
IEBAIFRSQUNFX0VWRU5UKGluZXRfc29ja19zZXRfc3RhdGUsCiAJKSwKIAogCVRQX2Zhc3RfYXNz
aWduKAotCQlzdHJ1Y3QgaW5ldF9zb2NrICppbmV0ID0gaW5ldF9zayhzayk7CisJCWNvbnN0IHN0
cnVjdCBpbmV0X3NvY2sgKmluZXQgPSBpbmV0X3NrKHNrKTsKIAkJc3RydWN0IGluNl9hZGRyICpw
aW42OwogCQlfX2JlMzIgKnAzMjsKIApAQCAtMjIyLDcgKzIyMiw3IEBAIFRSQUNFX0VWRU5UKGlu
ZXRfc2tfZXJyb3JfcmVwb3J0LAogCSksCiAKIAlUUF9mYXN0X2Fzc2lnbigKLQkJc3RydWN0IGlu
ZXRfc29jayAqaW5ldCA9IGluZXRfc2soc2spOworCQljb25zdCBzdHJ1Y3QgaW5ldF9zb2NrICpp
bmV0ID0gaW5ldF9zayhzayk7CiAJCXN0cnVjdCBpbjZfYWRkciAqcGluNjsKIAkJX19iZTMyICpw
MzI7CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3RjcC5oIGIvaW5jbHVkZS90
cmFjZS9ldmVudHMvdGNwLmgKaW5kZXggOTAxYjQ0MDIzOGQ1Li5iZjA2ZGI4ZDIwNDYgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvdHJhY2UvZXZlbnRzL3RjcC5oCisrKyBiL2luY2x1ZGUvdHJhY2UvZXZl
bnRzL3RjcC5oCkBAIC02Nyw3ICs2Nyw3IEBAIERFQ0xBUkVfRVZFTlRfQ0xBU1ModGNwX2V2ZW50
X3NrX3NrYiwKIAkpLAogCiAJVFBfZmFzdF9hc3NpZ24oCi0JCXN0cnVjdCBpbmV0X3NvY2sgKmlu
ZXQgPSBpbmV0X3NrKHNrKTsKKwkJY29uc3Qgc3RydWN0IGluZXRfc29jayAqaW5ldCA9IGluZXRf
c2soc2spOwogCQlfX2JlMzIgKnAzMjsKIAogCQlfX2VudHJ5LT5za2JhZGRyID0gc2tiOwpkaWZm
IC0tZ2l0IGEvbmV0L2lwdjQvaXBfb3V0cHV0LmMgYi9uZXQvaXB2NC9pcF9vdXRwdXQuYwppbmRl
eCA0ZTRlMzA4YzMyMzAuLjY0OTcxMDU0ZjBjNSAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvaXBfb3V0
cHV0LmMKKysrIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMKQEAgLTEyOSw3ICsxMjksNyBAQCBpbnQg
aXBfbG9jYWxfb3V0KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiKQogfQogRVhQT1JUX1NZTUJPTF9HUEwoaXBfbG9jYWxfb3V0KTsKIAotc3RhdGlj
IGlubGluZSBpbnQgaXBfc2VsZWN0X3R0bChzdHJ1Y3QgaW5ldF9zb2NrICppbmV0LCBzdHJ1Y3Qg
ZHN0X2VudHJ5ICpkc3QpCitzdGF0aWMgaW5saW5lIGludCBpcF9zZWxlY3RfdHRsKGNvbnN0IHN0
cnVjdCBpbmV0X3NvY2sgKmluZXQsIHN0cnVjdCBkc3RfZW50cnkgKmRzdCkKIHsKIAlpbnQgdHRs
ID0gaW5ldC0+dWNfdHRsOwogCkBAIC0xNDYsNyArMTQ2LDcgQEAgaW50IGlwX2J1aWxkX2FuZF9z
ZW5kX3BrdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBjb25zdCBzdHJ1Y3Qgc29jayAqc2ssCiAJCQkg
IF9fYmUzMiBzYWRkciwgX19iZTMyIGRhZGRyLCBzdHJ1Y3QgaXBfb3B0aW9uc19yY3UgKm9wdCwK
IAkJCSAgdTggdG9zKQogewotCXN0cnVjdCBpbmV0X3NvY2sgKmluZXQgPSBpbmV0X3NrKHNrKTsK
Kwljb25zdCBzdHJ1Y3QgaW5ldF9zb2NrICppbmV0ID0gaW5ldF9zayhzayk7CiAJc3RydWN0IHJ0
YWJsZSAqcnQgPSBza2JfcnRhYmxlKHNrYik7CiAJc3RydWN0IG5ldCAqbmV0ID0gc29ja19uZXQo
c2spOwogCXN0cnVjdCBpcGhkciAqaXBoOwpkaWZmIC0tZ2l0IGEvbmV0L21wdGNwL3NvY2tvcHQu
YyBiL25ldC9tcHRjcC9zb2Nrb3B0LmMKaW5kZXggOGE5NjU2MjQ4YjBmLi41Y2VmNGQzZDIxYWMg
MTAwNjQ0Ci0tLSBhL25ldC9tcHRjcC9zb2Nrb3B0LmMKKysrIGIvbmV0L21wdGNwL3NvY2tvcHQu
YwpAQCAtMTA0Niw3ICsxMDQ2LDcgQEAgc3RhdGljIGludCBtcHRjcF9nZXRzb2Nrb3B0X3RjcGlu
Zm8oc3RydWN0IG1wdGNwX3NvY2sgKm1zaywgY2hhciBfX3VzZXIgKm9wdHZhbCwKIAogc3RhdGlj
IHZvaWQgbXB0Y3BfZ2V0X3N1Yl9hZGRycyhjb25zdCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBt
cHRjcF9zdWJmbG93X2FkZHJzICphKQogewotCXN0cnVjdCBpbmV0X3NvY2sgKmluZXQgPSBpbmV0
X3NrKHNrKTsKKwljb25zdCBzdHJ1Y3QgaW5ldF9zb2NrICppbmV0ID0gaW5ldF9zayhzayk7CiAK
IAltZW1zZXQoYSwgMCwgc2l6ZW9mKCphKSk7CiAKZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2xzbV9h
dWRpdC5jIGIvc2VjdXJpdHkvbHNtX2F1ZGl0LmMKaW5kZXggYTczNTViNGI5YmI4Li4zNjhlNzdj
YTQzYzQgMTAwNjQ0Ci0tLSBhL3NlY3VyaXR5L2xzbV9hdWRpdC5jCisrKyBiL3NlY3VyaXR5L2xz
bV9hdWRpdC5jCkBAIC0zMTAsMTQgKzMxMCwxNCBAQCBzdGF0aWMgdm9pZCBkdW1wX2NvbW1vbl9h
dWRpdF9kYXRhKHN0cnVjdCBhdWRpdF9idWZmZXIgKmFiLAogCWNhc2UgTFNNX0FVRElUX0RBVEFf
TkVUOgogCQlpZiAoYS0+dS5uZXQtPnNrKSB7CiAJCQljb25zdCBzdHJ1Y3Qgc29jayAqc2sgPSBh
LT51Lm5ldC0+c2s7Ci0JCQlzdHJ1Y3QgdW5peF9zb2NrICp1OworCQkJY29uc3Qgc3RydWN0IHVu
aXhfc29jayAqdTsKIAkJCXN0cnVjdCB1bml4X2FkZHJlc3MgKmFkZHI7CiAJCQlpbnQgbGVuID0g
MDsKIAkJCWNoYXIgKnAgPSBOVUxMOwogCiAJCQlzd2l0Y2ggKHNrLT5za19mYW1pbHkpIHsKIAkJ
CWNhc2UgQUZfSU5FVDogewotCQkJCXN0cnVjdCBpbmV0X3NvY2sgKmluZXQgPSBpbmV0X3NrKHNr
KTsKKwkJCQljb25zdCBzdHJ1Y3QgaW5ldF9zb2NrICppbmV0ID0gaW5ldF9zayhzayk7CiAKIAkJ
CQlwcmludF9pcHY0X2FkZHIoYWIsIGluZXQtPmluZXRfcmN2X3NhZGRyLAogCQkJCQkJaW5ldC0+
aW5ldF9zcG9ydCwKQEAgLTMyOSw3ICszMjksNyBAQCBzdGF0aWMgdm9pZCBkdW1wX2NvbW1vbl9h
dWRpdF9kYXRhKHN0cnVjdCBhdWRpdF9idWZmZXIgKmFiLAogCQkJfQogI2lmIElTX0VOQUJMRUQo
Q09ORklHX0lQVjYpCiAJCQljYXNlIEFGX0lORVQ2OiB7Ci0JCQkJc3RydWN0IGluZXRfc29jayAq
aW5ldCA9IGluZXRfc2soc2spOworCQkJCWNvbnN0IHN0cnVjdCBpbmV0X3NvY2sgKmluZXQgPSBp
bmV0X3NrKHNrKTsKIAogCQkJCXByaW50X2lwdjZfYWRkcihhYiwgJnNrLT5za192Nl9yY3Zfc2Fk
ZHIsCiAJCQkJCQlpbmV0LT5pbmV0X3Nwb3J0LAo=
--0000000000001c92b805f6f9a057--
