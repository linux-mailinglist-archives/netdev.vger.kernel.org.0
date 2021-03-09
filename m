Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46E332105
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhCIIpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhCIIpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E48C06174A;
        Tue,  9 Mar 2021 00:45:32 -0800 (PST)
Message-Id: <20210309084203.995862150@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mZxOEHDPd7/Yp3jcQ6vX00DvouRsaIVMYYEagknQzH4=;
        b=Pem8P80FNqHdBxpXQLkPBDFYuiHjeDymKfehbwsz/b1kGrF8hxRZHjcB0BhbEi0tYFK3w/
        BvNAqsOu+EnaeExoSwWbeBeauy2mlnaXuFGPa7JcLx2A9v/k4eCe6RRM+U0+r7S06BNwQx
        wUsQPMPUp19sXB+xZ121zRjjElwqfff7Z2/PiVvr047M3uP9RlloCoXzjrmHJfqiqW+avM
        pvX/W6cykYbmm0w34eTR4Df24lH+ibfjDqUFX7etZybTsYGnIuHufnDnv+rQttkR7bqNPb
        5Z8XsGmKkjpCta/WCKgUVCL2cGyobxfPP4i9UE3C2nlW5Qmi1idzLoQ+AE0/7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mZxOEHDPd7/Yp3jcQ6vX00DvouRsaIVMYYEagknQzH4=;
        b=NgBOeQII7dm+zP1gHyz4eJT6xN4otLYu1EkP7jvNbsyhCMaNZ4c2OHSt4hh2ZU9hqPBolR
        Rk7BixzutQhr0UCA==
Date:   Tue, 09 Mar 2021 09:42:03 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [patch 00/14] tasklets: Replace the spin wait loops and make it RT safe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBhIGZvbGxvdyB1cCB0byB0aGUgcmV2aWV3IGNvbW1lbnRzIG9mIHRoZSBzZXJpZXMg
d2hpY2ggbWFrZXMKc29mdGlycSBwcm9jZXNzaW5nIFBSRUVNUFRfUlQgc2FmZToKCiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9yLzIwMjAxMjA3MTE0NzQzLkdLMzA0MEBoaXJlei5wcm9ncmFtbWlu
Zy5raWNrcy1hc3MubmV0CgpQZXRlciBzdWdnZXN0ZWQgdG8gcmVwbGFjZSB0aGUgc3BpbiB3YWl0
aW5nIGluIHRhc2tsZXRfZGlzYWJsZSgpIGFuZAp0YXNrbGV0X2tpbGwoKSB3aXRoIHdhaXRfZXZl
bnQoKS4gVGhpcyBhbHNvIGdldHMgcmlkIG9mIHRoZSBpbGwgZGVmaW5lZApzY2hlZF95aWVsZCgp
IGluIHRhc2tsZXRfa2lsbCgpLgoKQW5hbHl6aW5nIGFsbCB1c2FnZSBzaXRlcyBvZiB0YXNrbGV0
X2Rpc2FibGUoKSBhbmQgdGFza2xldF91bmxvY2tfd2FpdCgpIHdlCmZvdW5kIHRoYXQgbW9zdCBv
ZiB0aGVtIGFyZSBzYWZlIHRvIGJlIGNvbnZlcnRlZCB0byBhIHNsZWVwaW5nIHdhaXQuCgpPbmx5
IGEgZmV3IGluc3RhbmNlcyBpbnZva2UgdGFza2xldF9kaXNhYmxlKCkgZnJvbSBhdG9taWMgY29u
dGV4dC4gQSBmZXcKYnVncyB3aGljaCBoYXZlIGJlZW4gZm91bmQgaW4gY291cnNlIG9mIHRoaXMg
YW5hbHlzaXMgaGF2ZSBiZWVuIGFscmVhZHkKYWRkcmVzc2VkIHNlcGVyYXRlbHkuCgpUaGUgZm9s
bG93aW5nIHNlcmllcyB0YWtlcyB0aGUgZm9sbG93aW5nIGFwcHJvYWNoOgoKICAgIDEpIFByb3Zp
ZGUgYSB2YXJpYW50IG9mIHRhc2tsZXRfZGlzYWJsZSgpIHdoaWNoIGNhbiBiZSBpbnZva2VkIGZy
b20KICAgICAgIGF0b21pYyBjb250ZXh0cwoKICAgIDIpIENvbnZlcnQgdGhlIHVzYWdlIHNpdGVz
IHdoaWNoIGNhbm5vdCBiZSBlYXNpbHkgY2hhbmdlZCB0byBhCiAgICAgICBzbGVlcGFibGUgd2Fp
dCB0byB1c2UgdGhpcyBuZXcgZnVuY3Rpb24KCiAgICAzKSBSZXBsYWNlIHRoZSBzcGluIHdhaXRz
IGluIHRhc2tsZXRfZGlzYWJsZSgpIGFuZCB0YXNrbGV0X2tpbGwoKSB3aXRoCiAgICAgICBzbGVl
cGFibGUgdmFyaWFudHMuCgpJZiB0aGlzIGlzIGFncmVlZCBvbiB0aGVuIHRoZSBtZXJnaW5nIGNh
biBiZSBlaXRoZXIgZG9uZSBpbiBidWxrIG9yIHRoZQpmaXJzdCA0IHBhdGNoZXMgY291bGQgYmUg
YXBwbGllZCBvbiB0b3Agb2YgcmMyIGFuZCB0YWdnZWQgZm9yIGNvbnN1bXB0aW9uCmluIHRoZSBy
ZWxldmFudCBzdWJzeXN0ZW0gdHJlZXMgKG5ldHdvcmtpbmcsIHBjaSwgZmlyZXdpcmUpLiBJbiB0
aGlzIGNhc2UKdGhlIGxhc3QgcGF0Y2ggd2hpY2ggY2hhbmdlcyB0aGUgaW1wbGVtZW50YXRpb24g
b2YgdGFza2xldF9kaXNhYmxlKCkgaGFzIHRvCmJlIHBvc3QtcG9uZWQgdW50aWwgYWxsIG90aGVy
IGNoYW5nZXMgaGF2ZSByZWFjaGVkIG1haW5saW5lLgoKVGhlIHNlcmllcyBpcyBhbHNvIGF2YWls
YWJsZSBmcm9tIGdpdDoKCiAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3RnbHgvZGV2ZWwuZ2l0IHRhc2tsZXQtMjAyMS0wMy0wOQoKVGhhbmtzLAoKCXRnbHgK
Cgo=
