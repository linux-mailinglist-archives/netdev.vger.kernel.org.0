Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24552F2630
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbhALCTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbhALCTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 21:19:07 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE7FC061794;
        Mon, 11 Jan 2021 18:18:27 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id d37so748315ybi.4;
        Mon, 11 Jan 2021 18:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/jqrwzJgo9eVxAXeM6jKN5/Sa/ECb+x63YL/dYcjaww=;
        b=FFITv9L+CRR9SKokSSwXQz08Vq3LSY2cvOh6eL3csUn+UHXj9+BmUeX/FJVtLc1ARd
         8uvDBieYmaE3usyRRAPtpOAr09KIp36kQkVlVX5xiQZw3oGsSskg/k10ndwYSjBG0RgM
         oObZb+eE+X8cAcxgl49Yvmykhn03v5Bd/pUrFaNRpzkBj+tm6QzgT296/wjiWaK/sHXB
         B5FyH4YOJRVZI8AnO+KujtJRAIE+NMj1Du9dJpCN1GA/1XbHee7q1z0YahQfSxCGJYSI
         qwueenfvDufy7ZPJ5bOfefW1s4khPt5096iogMDrxnZaPl+9Es5i3IpAbz7rupkvWhg4
         Z7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/jqrwzJgo9eVxAXeM6jKN5/Sa/ECb+x63YL/dYcjaww=;
        b=LxIRjM65Ahw+AyiT75D9MlODUDdNJ3AklKCVRJEEPFXaph9w2me4DUvVbTin9IDR2n
         8kBGAHApHQ46ZNeulLtV+R6KF+TvUbVlja3r1evO8TzMDV3bTAsAyd4wA+hTojvy9opV
         W+ALamw3auhJ8FGQiPNGgH7+tx78A6N7yT0jfVbSBBgjIpsBm95AGwHtJQhl1MKOgtJj
         DZNwKv/Ovgn1ooqSSfZ32jbUS3eu+BWCJSa4dGShNcyoYQPJnQaRSOT9SpKzInwmQUmt
         dNv1QVK+VZF+yujbmDBxFubpnOBnM6wLxzYzWZq3Ca4CYykZXUhW2qeZRIhgPDbPOL1S
         Asrw==
X-Gm-Message-State: AOAM5315hFPOGczrNeYLesGxcK5smnGNJp42UgYbVlPpUgGE/dPAYKO2
        tfdAagF4w2YKD7hpJaQENTFS2J0CX9BuhA1B60k=
X-Google-Smtp-Source: ABdhPJzQRUSeX3651DgjlAt22Gg2Gq9OwNSpiGrNACArTzDBmmQ/QHbpdc3Ar5s6EzSGzzwVlfmDq4782wvK4jKbnk0=
X-Received: by 2002:a25:880a:: with SMTP id c10mr3724649ybl.456.1610417906674;
 Mon, 11 Jan 2021 18:18:26 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Tue, 12 Jan 2021 10:18:00 +0800
Message-ID: <CAD-N9QWDdRDiud42D8HMeRabqVvQ+Pbz=qgbOYrvpUvjRFp05Q@mail.gmail.com>
Subject: "general protection fault in sctp_ulpevent_notify_peer_addr_change"
 and "general protection fault in sctp_ulpevent_nofity_peer_addr_change"
 should share the same root cause
To:     davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com,
        rkovhaev@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear developers,

I find that "general protection fault in l2cap_sock_getsockopt" and
"general protection fault in sco_sock_getsockopt" may be duplicated
bugs from the same root cause.

First, by comparing the PoC similarity after own minimization, we find
they share the same PoC. Second, the stack traces for both bug reports
are the same except for the last function. And the different last
functions are due to a function name change (typo fix) from
"sctp_ulpevent_nofity_peer_addr_change" to
"sctp_ulpevent_notify_peer_addr_change"

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
