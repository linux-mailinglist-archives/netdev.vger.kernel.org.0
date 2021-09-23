Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC054162A4
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhIWQFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbhIWQFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:05:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAF7C061574;
        Thu, 23 Sep 2021 09:04:22 -0700 (PDT)
Message-ID: <20210923153311.225307347@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632413059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HKJ62ec0H3rRqwouVaEOlCdmeDwscUCB9fggww1qtqs=;
        b=S9Sw4KaTyb9s7Z3KdYbFaJAvUzjpHUVpUTxvyQ3jFIhlWRMGgqgxLk8/cDw3/6XKvUpZZp
        dhPkgsAfepaag4dai3tsQG8H1SEb6OcdSZOt4ZOJ+L5fXItf38KOz+VqvC3n7RURS0RvCQ
        AOymsMXCjVfXsiR5+QYlShryPPOPagMf/WTMdP3bCxY4nDARQHkLdyUfBjfybnlnp7aDF4
        +1FziWh42JVQop5OoCpYLsWFXx4DjgT4Pae3ReQR206O4iu4W5dBMixmm0/zU/iKuBBxQg
        Lzba969dREamrSViMjsujMdwDyfjxU3YaUi5eaDsZEB1EpwUfhtSN4rB5GULJA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632413059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HKJ62ec0H3rRqwouVaEOlCdmeDwscUCB9fggww1qtqs=;
        b=qLgcomT0elm/TlKSiEwnkZ3rD3NJKvPZV3pfy2RnYzqCkiviMbALY7urqFmSkwiw4ven3n
        7eMZvc1fRymbs4Dw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Corporation <linuxwwan@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 00/11] hrtimers: Cleanup hrtimer_forward() [ab]use
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Thu, 23 Sep 2021 18:04:18 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QSByZWNlbnQgc3l6Ym90IHJlcG9ydCB1bmVhcnRoZWQgYWJ1c2Ugb2YgaHJ0aW1lcl9mb3J3YXJk
KCkgd2hpY2ggY2FuIGNhdXNlCnJ1bmF3YXkgdGltZXJzIGhvZ2dpbmcgdGhlIENQVSBpbiB0aW1l
ciBleHBpcnkgY29udGV4dCBieSByZWFybWluZyB0aGUKdGltZXIgaW4gdGhlIHBhc3Qgb3ZlciBh
bmQgb3Zlci4KClRoaXMgaGFwcGVucyB3aGVuIHRoZSBjYWxsZXIgdXNlcyB0aW1lci0+ZXhwaXJ5
IGZvciB0aGUgJ25vdycgYXJndW1lbnQgb2YKaHJ0aW1lcl9mb3J3YXJkKCkuIFRoYXQgd29ya3Mg
YXMgbG9uZyBhcyB0aGUgdGltZXIgZXhwaXJ5IGlzIG9uIHRpbWUsIGJ1dApjYW4gY2F1c2UgYSBs
b25nIHBlcmlvZCBvZiByZWFybS9maXJlIGxvb3BzIHdoaWNoIGhvZyB0aGUgQ1BVLiBFeHBpcmlu
ZwpsYXRlIGNhbiBoYXZlIHZhcmlvdXMgY2F1c2VzLCBidXQgb2J2aW91c2x5IHZpcnR1YWxpemF0
aW9uIGlzIHByb25lIHRvIHRoYXQKZHVlIHRvIFZDUFUgc2NoZWR1bGluZy4KClRoZSBjb3JyZWN0
IHVzYWdlIG9mIGhydGltZXJfZm9yd2FyZCgpIGlzIHRvIGhhbmQgdGhlIGN1cnJlbnQgdGltZSB0
byB0aGUKJ25vdycgYXJndW1lbnQgd2hpY2ggZW5zdXJlcyB0aGF0IHRoZSBuZXh0IGV2ZW50IG9u
IHRoZSBwZXJpb2RpYyB0aW1lIGxpbmUKaXMgcGFzdCBub3cuIFRoaXMgaXMgd2hhdCBocnRpbWVy
X2ZvcndhcmRfbm93KCkgcHJvdmlkZXMuCgpUaGUgZm9sbG93aW5nIHNlcmllcyBhZGRyZXNzZXMg
dGhpczoKCiAgICAxKSBBZGQgYSBkZWJ1ZyBtZWNoYW5pc20gdG8gdGhlIGhydGltZXIgZXhwaXJ5
IGxvb3AKCiAgICAyKSBDb252ZXJ0IGFsbCBocnRpbWVyX2ZvcndhcmQoKSB1c2FnZSBvdXRzaWRl
IG9mIGtlcm5lbC90aW1lLyB0bwogICAgICAgdXNlIGhydGltZXJfZm9yd2FyZF9ub3coKS4KCiAg
ICAzKSBDb25maW5lIGhydGltZXJfZm9yd2FyZCgpIHRvIGtlcm5lbC90aW1lLyBjb3JlIGNvZGUu
CgpUaGUgbWFjODAyMTFfaHdzaW0gcGF0Y2ggaGFzIGFscmVhZHkgYmVlbiBwaWNrZWQgdXAgYnkg
dGhlIHdpcmVsZXNzCm1haW50YWluZXIgYW5kIGFsbCBvdGhlciBwYXRjaGVzIHdoaWNoIGFmZmVj
dCB1c2FnZSBvdXRzaWRlIHRoZSBjb3JlIGNvZGUKY2FuIGJlIHBpY2tlZCB1cCBieSB0aGUgcmVs
ZXZhbnQgc3Vic3lzdGVtcy4gSWYgYSBtYWludGFpbmVyIHdhbnRzIG1lIHRvCnBpY2sgYSBwYXJ0
aWN1bGFyIHBhdGNoIHVwLCBwbGVhc2UgbGV0IG1lIGtub3cuCgpUaGUgbGFzdCBwYXRjaCB3aGlj
aCBjb25maW5lcyBocnRpbWVyX2ZvcndhcmQoKSB3aWxsIGJlIHBvc3Rwb25lZCB1bnRpbCBhbGwK
b3RoZXIgcGF0Y2hlcyBoYXZlIGJlZW4gbWVyZ2VkIGludG8gTGludXMgdHJlZS4KClRoZSBzZXJp
ZXMgaXMgYWxzbyBhdmFpbGFibGUgZnJvbSBnaXQ6CgogICAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RnbHgvZGV2ZWwuZ2l0IGhydGltZXIKClRoYW5rcywK
Cgl0Z2x4Ci0tLQogZHJpdmVycy9ncHUvZHJtL2k5MTUvaTkxNV9wbXUuYyAgICAgICAgfCAgICAy
IC0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hYzgwMjExX2h3c2ltLmMgIHwgICAgNCArLQogZHJp
dmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX2ltZW0uYyAgfCAgICA0ICstCiBkcml2ZXJzL3Bv
d2VyL3Jlc2V0L2x0YzI5NTItcG93ZXJvZmYuYyB8ICAgIDQgLS0KIGluY2x1ZGUvbGludXgvaHJ0
aW1lci5oICAgICAgICAgICAgICAgIHwgICAyNiAtLS0tLS0tLS0tLS0tLS0tLQogaW5jbHVkZS9s
aW51eC9wb3NpeC10aW1lcnMuaCAgICAgICAgICAgfCAgICAzICsrCiBrZXJuZWwvc2lnbmFsLmMg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgMTQgKy0tLS0tLS0tCiBrZXJuZWwvdGltZS9ocnRp
bWVyLmMgICAgICAgICAgICAgICAgICB8ICAgNDggKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKystCiBrZXJuZWwvdGltZS9pdGltZXIuYyAgICAgICAgICAgICAgICAgICB8ICAgMTMgKysr
KysrKysKIGtlcm5lbC90aW1lL3Bvc2l4LXRpbWVycy5jICAgICAgICAgICAgIHwgICA0MiArKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tCiBrZXJuZWwvdGltZS90aWNrLWludGVybmFsLmggICAg
ICAgICAgICB8ICAgIDEgCiBuZXQvY2FuL2JjbS5jICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgIDIgLQogc291bmQvZHJpdmVycy9wY3NwL3Bjc3BfbGliLmMgICAgICAgICAgfCAgICAyIC0K
IDEzIGZpbGVzIGNoYW5nZWQsIDkyIGluc2VydGlvbnMoKyksIDczIGRlbGV0aW9ucygtKQoK
