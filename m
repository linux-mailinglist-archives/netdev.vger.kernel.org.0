Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6253DDCA
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 20:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347059AbiFES6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 14:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiFES6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 14:58:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB81A25EB5
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 11:58:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id kq6so12146778ejb.11
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 11:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1qGM9AfAz5/n6lUTPqObNtC7EoqDOUU+o+Il+9aE+Ec=;
        b=RbHJpKTI4tdZdCKyqIEmQjSimK3Lnp2hoKxfw8BKwTEpHHGfIEBF2uEYgPKXwzKi2N
         UeJLSeio74InV/7ZcxVz1DWTKbgJJgXEruPB4JDVGhUbdgsjq/On3na2seTmH9z12CPW
         NepnbS1bArWiIf0ek4joVzL6SMaAZjNe7Q9D0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1qGM9AfAz5/n6lUTPqObNtC7EoqDOUU+o+Il+9aE+Ec=;
        b=IPSzlM20NzuF6rkVfeLssvMmA0gGhn8KRONsppwS3X2/fwIpBFtTWIzZJr25TCCx3o
         K02JVp6l+FS+NgpMXJl2oLy4L3iy/iJNUo2Y+TlEZazF5MomTLGZZoB1acAu/7PCsrqf
         U29cvlEMq0t0JkAayOtiCyxw/Fjb8orOzYlMF03/zZV9gsDhwUuerPPrKhAsILvMFRx4
         S8EqqHtVddlF/9tK05/cm13hH8ydxfLXawX8OUagfB7RTG8Za5uJNxKoX/8JivhrKjI2
         03wJPp9sDacotpfuUQuj/WhoOyime+H4shekgYKT7Lq2vz12qXzPKIm3cmO0+Qb5gnSm
         DQIQ==
X-Gm-Message-State: AOAM532R6v40fyjTvlGrOie5pZIyjum5GwJGMw7Hv2NqEIUGOZBxfLnt
        m2Bm59HNl6EtViTr/y/EV3rCSc8WjlgEz7icpw0=
X-Google-Smtp-Source: ABdhPJx3saVqSQEwLL1pCRVJkuKmtsEl7CZfHUvaUJIHemeUpt9Cx9bzlKjDJRrfYD21p850MCAsJg==
X-Received: by 2002:a17:907:72ca:b0:6fe:fec2:935 with SMTP id du10-20020a17090772ca00b006fefec20935mr18265087ejc.515.1654455510961;
        Sun, 05 Jun 2022 11:58:30 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id o19-20020a1709061b1300b006fed85c1a8fsm5473470ejg.202.2022.06.05.11.58.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jun 2022 11:58:30 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id o9so6664744wmd.0
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 11:58:30 -0700 (PDT)
X-Received: by 2002:a05:600c:2e07:b0:39c:37df:2c40 with SMTP id
 o7-20020a05600c2e0700b0039c37df2c40mr15221042wmf.154.1654455125158; Sun, 05
 Jun 2022 11:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220605162537.1604762-1-yury.norov@gmail.com> <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com>
In-Reply-To: <CAHk-=whqgEA=OOPQs7JF=xps3VxjJ5uUnfXgzTv4gqTDhraZFA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 5 Jun 2022 11:51:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wib4F=71sXhamdPzLEZ9S4Lw4Dv3N2jLxv6-i8fHfMeDQ@mail.gmail.com>
Message-ID: <CAHk-=wib4F=71sXhamdPzLEZ9S4Lw4Dv3N2jLxv6-i8fHfMeDQ@mail.gmail.com>
Subject: Re: [PATCH] net/bluetooth: fix erroneous use of bitmap_from_u64()
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Guo Ren <guoren@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-csky@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Content-Type: multipart/mixed; boundary="00000000000008827805e0b7da33"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000008827805e0b7da33
Content-Type: text/plain; charset="UTF-8"

On Sun, Jun 5, 2022 at 9:34 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That code shouldn't use DECLARE_BITMAP() at all, it should just use
>
>     struct bdaddr_list_with_flags {
>             ..
>             unsigned long flags;
>     };
>
> and then use '&br_params->flags' when it needs the actual atomic
> 'set_bit()' things and friends,

Actually, I'm not convinced those things should be atomic at all.

*Most* of the accesses to those connection flags seem to be with
hci_dev_lock() held, and the ones that aren't can't possibly depend on
atomicity since those things are currently copied around with random
other "copy bitmaps" functions.

So I think the bluetooth code would actually be much better off with
something like

    /* Bitmask of connection flags */
    enum hci_conn_flags {
        HCI_CONN_FLAG_REMOTE_WAKEUP = 1,
        HCI_CONN_FLAG_DEVICE_PRIVACY = 2,
    };
    typedef u8 hci_conn_flags_t;

instead of playing games with DECLARE_BITMAP() and then using a mix of
atomic set_bit/clear_bit() and random non-atomic "copy bitmap values
around".

This attached patch builds cleanly for me, doing the above. But see a
few comments about those atomicity issues...

And no, it doesn't really need that new "hci_conn_flags_t", and it
could just use "u32" (which is what "current_flags" and
"supported_flags" use in the code), but those structures that contain
those connection flags do seem to have various other byte fields and
it would appear to pack better using just that simple one-byte type.

It *literally* just uses two bits in it, after all, and as mentioned,
the whole atomicity situation right now is very very dubious, so it
seems to make sense to do something like this.

Reactions?

                 Linus

--00000000000008827805e0b7da33
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_l41nsbq30>
X-Attachment-Id: f_l41nsbq30

IGluY2x1ZGUvbmV0L2JsdWV0b290aC9oY2lfY29yZS5oIHwgMTcgKysrKysrKy0tLS0tLS0tLS0K
IG5ldC9ibHVldG9vdGgvaGNpX2NvcmUuYyAgICAgICAgIHwgIDQgKystLQogbmV0L2JsdWV0b290
aC9oY2lfcmVxdWVzdC5jICAgICAgfCAgMiArLQogbmV0L2JsdWV0b290aC9oY2lfc3luYy5jICAg
ICAgICAgfCAgNiArKystLS0KIG5ldC9ibHVldG9vdGgvbWdtdC5jICAgICAgICAgICAgIHwgMzcg
KysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogNSBmaWxlcyBjaGFuZ2VkLCAy
NyBpbnNlcnRpb25zKCspLCAzOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25l
dC9ibHVldG9vdGgvaGNpX2NvcmUuaCBiL2luY2x1ZGUvbmV0L2JsdWV0b290aC9oY2lfY29yZS5o
CmluZGV4IDVhNTJhMjAxOGI1Ni4uYzBlYTJhNDg5MmIxIDEwMDY0NAotLS0gYS9pbmNsdWRlL25l
dC9ibHVldG9vdGgvaGNpX2NvcmUuaAorKysgYi9pbmNsdWRlL25ldC9ibHVldG9vdGgvaGNpX2Nv
cmUuaApAQCAtMTU1LDIxICsxNTUsMTggQEAgc3RydWN0IGJkYWRkcl9saXN0X3dpdGhfaXJrIHsK
IAl1OCBsb2NhbF9pcmtbMTZdOwogfTsKIAorLyogQml0bWFzayBvZiBjb25uZWN0aW9uIGZsYWdz
ICovCiBlbnVtIGhjaV9jb25uX2ZsYWdzIHsKLQlIQ0lfQ09OTl9GTEFHX1JFTU9URV9XQUtFVVAs
Ci0JSENJX0NPTk5fRkxBR19ERVZJQ0VfUFJJVkFDWSwKLQotCV9fSENJX0NPTk5fTlVNX0ZMQUdT
LAorCUhDSV9DT05OX0ZMQUdfUkVNT1RFX1dBS0VVUCA9IDEsCisJSENJX0NPTk5fRkxBR19ERVZJ
Q0VfUFJJVkFDWSA9IDIsCiB9OwotCi0vKiBNYWtlIHN1cmUgbnVtYmVyIG9mIGZsYWdzIGRvZXNu
J3QgZXhjZWVkIHNpemVvZihjdXJyZW50X2ZsYWdzKSAqLwotc3RhdGljX2Fzc2VydChfX0hDSV9D
T05OX05VTV9GTEFHUyA8IDMyKTsKK3R5cGVkZWYgdTggaGNpX2Nvbm5fZmxhZ3NfdDsKIAogc3Ry
dWN0IGJkYWRkcl9saXN0X3dpdGhfZmxhZ3MgewogCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKIAli
ZGFkZHJfdCBiZGFkZHI7CiAJdTggYmRhZGRyX3R5cGU7Ci0JREVDTEFSRV9CSVRNQVAoZmxhZ3Ms
IF9fSENJX0NPTk5fTlVNX0ZMQUdTKTsKKwloY2lfY29ubl9mbGFnc190IGZsYWdzOwogfTsKIAog
c3RydWN0IGJ0X3V1aWQgewpAQCAtNTc2LDcgKzU3Myw3IEBAIHN0cnVjdCBoY2lfZGV2IHsKIAlz
dHJ1Y3QgcmZraWxsCQkqcmZraWxsOwogCiAJREVDTEFSRV9CSVRNQVAoZGV2X2ZsYWdzLCBfX0hD
SV9OVU1fRkxBR1MpOwotCURFQ0xBUkVfQklUTUFQKGNvbm5fZmxhZ3MsIF9fSENJX0NPTk5fTlVN
X0ZMQUdTKTsKKwloY2lfY29ubl9mbGFnc190CWNvbm5fZmxhZ3M7CiAKIAlfX3M4CQkJYWR2X3R4
X3Bvd2VyOwogCV9fdTgJCQlhZHZfZGF0YVtIQ0lfTUFYX0VYVF9BRF9MRU5HVEhdOwpAQCAtNzc1
LDcgKzc3Miw3IEBAIHN0cnVjdCBoY2lfY29ubl9wYXJhbXMgewogCiAJc3RydWN0IGhjaV9jb25u
ICpjb25uOwogCWJvb2wgZXhwbGljaXRfY29ubmVjdDsKLQlERUNMQVJFX0JJVE1BUChmbGFncywg
X19IQ0lfQ09OTl9OVU1fRkxBR1MpOworCWhjaV9jb25uX2ZsYWdzX3QgZmxhZ3M7CiAJdTggIHBy
aXZhY3lfbW9kZTsKIH07CiAKZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvaGNpX2NvcmUuYyBi
L25ldC9ibHVldG9vdGgvaGNpX2NvcmUuYwppbmRleCA1YWJiMmNhNWIxMjkuLjU5YTVjMTM0MWMy
NiAxMDA2NDQKLS0tIGEvbmV0L2JsdWV0b290aC9oY2lfY29yZS5jCisrKyBiL25ldC9ibHVldG9v
dGgvaGNpX2NvcmUuYwpAQCAtMjE1Myw3ICsyMTUzLDcgQEAgaW50IGhjaV9iZGFkZHJfbGlzdF9h
ZGRfd2l0aF9mbGFncyhzdHJ1Y3QgbGlzdF9oZWFkICpsaXN0LCBiZGFkZHJfdCAqYmRhZGRyLAog
CiAJYmFjcHkoJmVudHJ5LT5iZGFkZHIsIGJkYWRkcik7CiAJZW50cnktPmJkYWRkcl90eXBlID0g
dHlwZTsKLQliaXRtYXBfZnJvbV91NjQoZW50cnktPmZsYWdzLCBmbGFncyk7CisJZW50cnktPmZs
YWdzID0gZmxhZ3M7CiAKIAlsaXN0X2FkZCgmZW50cnktPmxpc3QsIGxpc3QpOwogCkBAIC0yNjM0
LDcgKzI2MzQsNyBAQCBpbnQgaGNpX3JlZ2lzdGVyX2RldihzdHJ1Y3QgaGNpX2RldiAqaGRldikK
IAkgKiBjYWxsYmFjay4KIAkgKi8KIAlpZiAoaGRldi0+d2FrZXVwKQotCQlzZXRfYml0KEhDSV9D
T05OX0ZMQUdfUkVNT1RFX1dBS0VVUCwgaGRldi0+Y29ubl9mbGFncyk7CisJCWhkZXYtPmNvbm5f
ZmxhZ3MgfD0gSENJX0NPTk5fRkxBR19SRU1PVEVfV0FLRVVQOwogCiAJaGNpX3NvY2tfZGV2X2V2
ZW50KGhkZXYsIEhDSV9ERVZfUkVHKTsKIAloY2lfZGV2X2hvbGQoaGRldik7CmRpZmYgLS1naXQg
YS9uZXQvYmx1ZXRvb3RoL2hjaV9yZXF1ZXN0LmMgYi9uZXQvYmx1ZXRvb3RoL2hjaV9yZXF1ZXN0
LmMKaW5kZXggNjM1Y2M1ZmI0NTFlLi4zOGVjYWY5MjY0ZWUgMTAwNjQ0Ci0tLSBhL25ldC9ibHVl
dG9vdGgvaGNpX3JlcXVlc3QuYworKysgYi9uZXQvYmx1ZXRvb3RoL2hjaV9yZXF1ZXN0LmMKQEAg
LTQ4Miw3ICs0ODIsNyBAQCBzdGF0aWMgaW50IGFkZF90b19hY2NlcHRfbGlzdChzdHJ1Y3QgaGNp
X3JlcXVlc3QgKnJlcSwKIAogCS8qIER1cmluZyBzdXNwZW5kLCBvbmx5IHdha2VhYmxlIGRldmlj
ZXMgY2FuIGJlIGluIGFjY2VwdCBsaXN0ICovCiAJaWYgKGhkZXYtPnN1c3BlbmRlZCAmJgotCSAg
ICAhdGVzdF9iaXQoSENJX0NPTk5fRkxBR19SRU1PVEVfV0FLRVVQLCBwYXJhbXMtPmZsYWdzKSkK
KwkgICAgIShwYXJhbXMtPmZsYWdzICYgSENJX0NPTk5fRkxBR19SRU1PVEVfV0FLRVVQKSkKIAkJ
cmV0dXJuIDA7CiAKIAkqbnVtX2VudHJpZXMgKz0gMTsKZGlmZiAtLWdpdCBhL25ldC9ibHVldG9v
dGgvaGNpX3N5bmMuYyBiL25ldC9ibHVldG9vdGgvaGNpX3N5bmMuYwppbmRleCA0ZDIyMDNjNWYx
YmIuLjI4NmQ2NzY3ZjAxNyAxMDA2NDQKLS0tIGEvbmV0L2JsdWV0b290aC9oY2lfc3luYy5jCisr
KyBiL25ldC9ibHVldG9vdGgvaGNpX3N5bmMuYwpAQCAtMTYzNyw3ICsxNjM3LDcgQEAgc3RhdGlj
IGludCBoY2lfbGVfc2V0X3ByaXZhY3lfbW9kZV9zeW5jKHN0cnVjdCBoY2lfZGV2ICpoZGV2LAog
CSAqIGluZGljYXRlcyB0aGF0IExMIFByaXZhY3kgaGFzIGJlZW4gZW5hYmxlZCBhbmQKIAkgKiBI
Q0lfT1BfTEVfU0VUX1BSSVZBQ1lfTU9ERSBpcyBzdXBwb3J0ZWQuCiAJICovCi0JaWYgKCF0ZXN0
X2JpdChIQ0lfQ09OTl9GTEFHX0RFVklDRV9QUklWQUNZLCBwYXJhbXMtPmZsYWdzKSkKKwlpZiAo
IShwYXJhbXMtPmZsYWdzICYgSENJX0NPTk5fRkxBR19ERVZJQ0VfUFJJVkFDWSkpCiAJCXJldHVy
biAwOwogCiAJaXJrID0gaGNpX2ZpbmRfaXJrX2J5X2FkZHIoaGRldiwgJnBhcmFtcy0+YWRkciwg
cGFyYW1zLT5hZGRyX3R5cGUpOwpAQCAtMTY2Niw3ICsxNjY2LDcgQEAgc3RhdGljIGludCBoY2lf
bGVfYWRkX2FjY2VwdF9saXN0X3N5bmMoc3RydWN0IGhjaV9kZXYgKmhkZXYsCiAKIAkvKiBEdXJp
bmcgc3VzcGVuZCwgb25seSB3YWtlYWJsZSBkZXZpY2VzIGNhbiBiZSBpbiBhY2NlcHRsaXN0ICov
CiAJaWYgKGhkZXYtPnN1c3BlbmRlZCAmJgotCSAgICAhdGVzdF9iaXQoSENJX0NPTk5fRkxBR19S
RU1PVEVfV0FLRVVQLCBwYXJhbXMtPmZsYWdzKSkKKwkgICAgIShwYXJhbXMtPmZsYWdzICYgSENJ
X0NPTk5fRkxBR19SRU1PVEVfV0FLRVVQKSkKIAkJcmV0dXJuIDA7CiAKIAkvKiBTZWxlY3QgZmls
dGVyIHBvbGljeSB0byBhY2NlcHQgYWxsIGFkdmVydGlzaW5nICovCkBAIC00ODg4LDcgKzQ4ODgs
NyBAQCBzdGF0aWMgaW50IGhjaV91cGRhdGVfZXZlbnRfZmlsdGVyX3N5bmMoc3RydWN0IGhjaV9k
ZXYgKmhkZXYpCiAJaGNpX2NsZWFyX2V2ZW50X2ZpbHRlcl9zeW5jKGhkZXYpOwogCiAJbGlzdF9m
b3JfZWFjaF9lbnRyeShiLCAmaGRldi0+YWNjZXB0X2xpc3QsIGxpc3QpIHsKLQkJaWYgKCF0ZXN0
X2JpdChIQ0lfQ09OTl9GTEFHX1JFTU9URV9XQUtFVVAsIGItPmZsYWdzKSkKKwkJaWYgKCEoYi0+
ZmxhZ3MgJiBIQ0lfQ09OTl9GTEFHX1JFTU9URV9XQUtFVVApKQogCQkJY29udGludWU7CiAKIAkJ
YnRfZGV2X2RiZyhoZGV2LCAiQWRkaW5nIGV2ZW50IGZpbHRlcnMgZm9yICVwTVIiLCAmYi0+YmRh
ZGRyKTsKZGlmZiAtLWdpdCBhL25ldC9ibHVldG9vdGgvbWdtdC5jIGIvbmV0L2JsdWV0b290aC9t
Z210LmMKaW5kZXggNzQ5MzdhODM0NjQ4Li5hZTc1OGFiMWI1NTggMTAwNjQ0Ci0tLSBhL25ldC9i
bHVldG9vdGgvbWdtdC5jCisrKyBiL25ldC9ibHVldG9vdGgvbWdtdC5jCkBAIC00MDEzLDEwICs0
MDEzLDExIEBAIHN0YXRpYyBpbnQgZXhwX2xsX3ByaXZhY3lfZmVhdHVyZV9jaGFuZ2VkKGJvb2wg
ZW5hYmxlZCwgc3RydWN0IGhjaV9kZXYgKmhkZXYsCiAJbWVtY3B5KGV2LnV1aWQsIHJwYV9yZXNv
bHV0aW9uX3V1aWQsIDE2KTsKIAlldi5mbGFncyA9IGNwdV90b19sZTMyKChlbmFibGVkID8gQklU
KDApIDogMCkgfCBCSVQoMSkpOwogCisJLy8gRG8gd2UgbmVlZCB0byBiZSBhdG9taWMgd2l0aCB0
aGUgY29ubl9mbGFncz8KIAlpZiAoZW5hYmxlZCAmJiBwcml2YWN5X21vZGVfY2FwYWJsZShoZGV2
KSkKLQkJc2V0X2JpdChIQ0lfQ09OTl9GTEFHX0RFVklDRV9QUklWQUNZLCBoZGV2LT5jb25uX2Zs
YWdzKTsKKwkJaGRldi0+Y29ubl9mbGFncyB8PSBIQ0lfQ09OTl9GTEFHX0RFVklDRV9QUklWQUNZ
OwogCWVsc2UKLQkJY2xlYXJfYml0KEhDSV9DT05OX0ZMQUdfREVWSUNFX1BSSVZBQ1ksIGhkZXYt
PmNvbm5fZmxhZ3MpOworCQloZGV2LT5jb25uX2ZsYWdzICY9IH5IQ0lfQ09OTl9GTEFHX0RFVklD
RV9QUklWQUNZOwogCiAJcmV0dXJuIG1nbXRfbGltaXRlZF9ldmVudChNR01UX0VWX0VYUF9GRUFU
VVJFX0NIQU5HRUQsIGhkZXYsCiAJCQkJICAmZXYsIHNpemVvZihldiksCkBAIC00NDM1LDggKzQ0
MzYsNyBAQCBzdGF0aWMgaW50IGdldF9kZXZpY2VfZmxhZ3Moc3RydWN0IHNvY2sgKnNrLCBzdHJ1
Y3QgaGNpX2RldiAqaGRldiwgdm9pZCAqZGF0YSwKIAogCWhjaV9kZXZfbG9jayhoZGV2KTsKIAot
CWJpdG1hcF90b19hcnIzMigmc3VwcG9ydGVkX2ZsYWdzLCBoZGV2LT5jb25uX2ZsYWdzLAotCQkJ
X19IQ0lfQ09OTl9OVU1fRkxBR1MpOworCXN1cHBvcnRlZF9mbGFncyA9IGhkZXYtPmNvbm5fZmxh
Z3M7CiAKIAltZW1zZXQoJnJwLCAwLCBzaXplb2YocnApKTsKIApAQCAtNDQ0Nyw4ICs0NDQ3LDcg
QEAgc3RhdGljIGludCBnZXRfZGV2aWNlX2ZsYWdzKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGhj
aV9kZXYgKmhkZXYsIHZvaWQgKmRhdGEsCiAJCWlmICghYnJfcGFyYW1zKQogCQkJZ290byBkb25l
OwogCi0JCWJpdG1hcF90b19hcnIzMigmY3VycmVudF9mbGFncywgYnJfcGFyYW1zLT5mbGFncywK
LQkJCQlfX0hDSV9DT05OX05VTV9GTEFHUyk7CisJCWN1cnJlbnRfZmxhZ3MgPSBicl9wYXJhbXMt
PmZsYWdzOwogCX0gZWxzZSB7CiAJCXBhcmFtcyA9IGhjaV9jb25uX3BhcmFtc19sb29rdXAoaGRl
diwgJmNwLT5hZGRyLmJkYWRkciwKIAkJCQkJCWxlX2FkZHJfdHlwZShjcC0+YWRkci50eXBlKSk7
CkBAIC00NDU2LDggKzQ0NTUsNyBAQCBzdGF0aWMgaW50IGdldF9kZXZpY2VfZmxhZ3Moc3RydWN0
IHNvY2sgKnNrLCBzdHJ1Y3QgaGNpX2RldiAqaGRldiwgdm9pZCAqZGF0YSwKIAkJaWYgKCFwYXJh
bXMpCiAJCQlnb3RvIGRvbmU7CiAKLQkJYml0bWFwX3RvX2FycjMyKCZjdXJyZW50X2ZsYWdzLCBw
YXJhbXMtPmZsYWdzLAotCQkJCV9fSENJX0NPTk5fTlVNX0ZMQUdTKTsKKwkJY3VycmVudF9mbGFn
cyA9IHBhcmFtcy0+ZmxhZ3M7CiAJfQogCiAJYmFjcHkoJnJwLmFkZHIuYmRhZGRyLCAmY3AtPmFk
ZHIuYmRhZGRyKTsKQEAgLTQ1MDIsOCArNDUwMCw4IEBAIHN0YXRpYyBpbnQgc2V0X2RldmljZV9m
bGFncyhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBoY2lfZGV2ICpoZGV2LCB2b2lkICpkYXRhLAog
CQkgICAmY3AtPmFkZHIuYmRhZGRyLCBjcC0+YWRkci50eXBlLAogCQkgICBfX2xlMzJfdG9fY3B1
KGN1cnJlbnRfZmxhZ3MpKTsKIAotCWJpdG1hcF90b19hcnIzMigmc3VwcG9ydGVkX2ZsYWdzLCBo
ZGV2LT5jb25uX2ZsYWdzLAotCQkJX19IQ0lfQ09OTl9OVU1fRkxBR1MpOworCS8vIFdlIHNob3Vs
ZCB0YWtlIGhjaV9kZXZfbG9jaygpIGVhcmx5LCBJIHRoaW5rLi4gY29ubl9mbGFncyBjYW4gY2hh
bmdlCisJc3VwcG9ydGVkX2ZsYWdzID0gaGRldi0+Y29ubl9mbGFnczsKIAogCWlmICgoc3VwcG9y
dGVkX2ZsYWdzIHwgY3VycmVudF9mbGFncykgIT0gc3VwcG9ydGVkX2ZsYWdzKSB7CiAJCWJ0X2Rl
dl93YXJuKGhkZXYsICJCYWQgZmxhZyBnaXZlbiAoMHgleCkgdnMgc3VwcG9ydGVkICgweCUweCki
LApAQCAtNDUxOSw3ICs0NTE3LDcgQEAgc3RhdGljIGludCBzZXRfZGV2aWNlX2ZsYWdzKHN0cnVj
dCBzb2NrICpzaywgc3RydWN0IGhjaV9kZXYgKmhkZXYsIHZvaWQgKmRhdGEsCiAJCQkJCQkJICAg
ICAgY3AtPmFkZHIudHlwZSk7CiAKIAkJaWYgKGJyX3BhcmFtcykgewotCQkJYml0bWFwX2Zyb21f
dTY0KGJyX3BhcmFtcy0+ZmxhZ3MsIGN1cnJlbnRfZmxhZ3MpOworCQkJYnJfcGFyYW1zLT5mbGFn
cyA9IGN1cnJlbnRfZmxhZ3M7CiAJCQlzdGF0dXMgPSBNR01UX1NUQVRVU19TVUNDRVNTOwogCQl9
IGVsc2UgewogCQkJYnRfZGV2X3dhcm4oaGRldiwgIk5vIHN1Y2ggQlIvRURSIGRldmljZSAlcE1S
ICgweCV4KSIsCkBAIC00NTI5LDE1ICs0NTI3LDExIEBAIHN0YXRpYyBpbnQgc2V0X2RldmljZV9m
bGFncyhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBoY2lfZGV2ICpoZGV2LCB2b2lkICpkYXRhLAog
CQlwYXJhbXMgPSBoY2lfY29ubl9wYXJhbXNfbG9va3VwKGhkZXYsICZjcC0+YWRkci5iZGFkZHIs
CiAJCQkJCQlsZV9hZGRyX3R5cGUoY3AtPmFkZHIudHlwZSkpOwogCQlpZiAocGFyYW1zKSB7Ci0J
CQlERUNMQVJFX0JJVE1BUChmbGFncywgX19IQ0lfQ09OTl9OVU1fRkxBR1MpOwotCi0JCQliaXRt
YXBfZnJvbV91NjQoZmxhZ3MsIGN1cnJlbnRfZmxhZ3MpOwotCiAJCQkvKiBEZXZpY2VzIHVzaW5n
IFJQQXMgY2FuIG9ubHkgYmUgcHJvZ3JhbW1lZCBpbiB0aGUKIAkJCSAqIGFjY2VwdGxpc3QgTEwg
UHJpdmFjeSBoYXMgYmVlbiBlbmFibGUgb3RoZXJ3aXNlIHRoZXkKIAkJCSAqIGNhbm5vdCBtYXJr
IEhDSV9DT05OX0ZMQUdfUkVNT1RFX1dBS0VVUC4KIAkJCSAqLwotCQkJaWYgKHRlc3RfYml0KEhD
SV9DT05OX0ZMQUdfUkVNT1RFX1dBS0VVUCwgZmxhZ3MpICYmCisJCQlpZiAoKGN1cnJlbnRfZmxh
Z3MgJiBIQ0lfQ09OTl9GTEFHX1JFTU9URV9XQUtFVVApICYmCiAJCQkgICAgIXVzZV9sbF9wcml2
YWN5KGhkZXYpICYmCiAJCQkgICAgaGNpX2ZpbmRfaXJrX2J5X2FkZHIoaGRldiwgJnBhcmFtcy0+
YWRkciwKIAkJCQkJCSBwYXJhbXMtPmFkZHJfdHlwZSkpIHsKQEAgLTQ1NDYsMTQgKzQ1NDAsMTMg
QEAgc3RhdGljIGludCBzZXRfZGV2aWNlX2ZsYWdzKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGhj
aV9kZXYgKmhkZXYsIHZvaWQgKmRhdGEsCiAJCQkJZ290byB1bmxvY2s7CiAJCQl9CiAKLQkJCWJp
dG1hcF9mcm9tX3U2NChwYXJhbXMtPmZsYWdzLCBjdXJyZW50X2ZsYWdzKTsKKwkJCXBhcmFtcy0+
ZmxhZ3MgPSBjdXJyZW50X2ZsYWdzOwogCQkJc3RhdHVzID0gTUdNVF9TVEFUVVNfU1VDQ0VTUzsK
IAogCQkJLyogVXBkYXRlIHBhc3NpdmUgc2NhbiBpZiBIQ0lfQ09OTl9GTEFHX0RFVklDRV9QUklW
QUNZCiAJCQkgKiBoYXMgYmVlbiBzZXQuCiAJCQkgKi8KLQkJCWlmICh0ZXN0X2JpdChIQ0lfQ09O
Tl9GTEFHX0RFVklDRV9QUklWQUNZLAotCQkJCSAgICAgcGFyYW1zLT5mbGFncykpCisJCQlpZiAo
cGFyYW1zLT5mbGFncyAmIEhDSV9DT05OX0ZMQUdfREVWSUNFX1BSSVZBQ1kpCiAJCQkJaGNpX3Vw
ZGF0ZV9wYXNzaXZlX3NjYW4oaGRldik7CiAJCX0gZWxzZSB7CiAJCQlidF9kZXZfd2FybihoZGV2
LCAiTm8gc3VjaCBMRSBkZXZpY2UgJXBNUiAoMHgleCkiLApAQCAtNzE1NCw4ICs3MTQ3LDcgQEAg
c3RhdGljIGludCBhZGRfZGV2aWNlKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IGhjaV9kZXYgKmhk
ZXYsCiAJCXBhcmFtcyA9IGhjaV9jb25uX3BhcmFtc19sb29rdXAoaGRldiwgJmNwLT5hZGRyLmJk
YWRkciwKIAkJCQkJCWFkZHJfdHlwZSk7CiAJCWlmIChwYXJhbXMpCi0JCQliaXRtYXBfdG9fYXJy
MzIoJmN1cnJlbnRfZmxhZ3MsIHBhcmFtcy0+ZmxhZ3MsCi0JCQkJCV9fSENJX0NPTk5fTlVNX0ZM
QUdTKTsKKwkJCWN1cnJlbnRfZmxhZ3MgPSBwYXJhbXMtPmZsYWdzOwogCX0KIAogCWVyciA9IGhj
aV9jbWRfc3luY19xdWV1ZShoZGV2LCBhZGRfZGV2aWNlX3N5bmMsIE5VTEwsIE5VTEwpOwpAQCAt
NzE2NCw4ICs3MTU2LDcgQEAgc3RhdGljIGludCBhZGRfZGV2aWNlKHN0cnVjdCBzb2NrICpzaywg
c3RydWN0IGhjaV9kZXYgKmhkZXYsCiAKIGFkZGVkOgogCWRldmljZV9hZGRlZChzaywgaGRldiwg
JmNwLT5hZGRyLmJkYWRkciwgY3AtPmFkZHIudHlwZSwgY3AtPmFjdGlvbik7Ci0JYml0bWFwX3Rv
X2FycjMyKCZzdXBwb3J0ZWRfZmxhZ3MsIGhkZXYtPmNvbm5fZmxhZ3MsCi0JCQlfX0hDSV9DT05O
X05VTV9GTEFHUyk7CisJc3VwcG9ydGVkX2ZsYWdzID0gaGRldi0+Y29ubl9mbGFnczsKIAlkZXZp
Y2VfZmxhZ3NfY2hhbmdlZChOVUxMLCBoZGV2LCAmY3AtPmFkZHIuYmRhZGRyLCBjcC0+YWRkci50
eXBlLAogCQkJICAgICBzdXBwb3J0ZWRfZmxhZ3MsIGN1cnJlbnRfZmxhZ3MpOwogCg==
--00000000000008827805e0b7da33--
