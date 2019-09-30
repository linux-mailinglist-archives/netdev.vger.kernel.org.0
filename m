Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3275C2B21
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 02:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfI3X7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:59:30 -0400
Received: from smtp1.cs.stanford.edu ([171.64.64.25]:38992 "EHLO
        smtp1.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3X7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:59:30 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:39651)
        by smtp1.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1iF5Zh-0001lw-GV
        for netdev@vger.kernel.org; Mon, 30 Sep 2019 16:59:30 -0700
Received: by mail-lj1-f177.google.com with SMTP id y3so11355483ljj.6
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 16:59:29 -0700 (PDT)
X-Gm-Message-State: APjAAAUt8nu8SF3rKxd2Djtqs5Ob+ikYHBOPIMDKHX+l7IvM2qaIOMNS
        vN2K+Hwk217JPQzbXC4WD3+3Qy3lnxWpfWQysdc=
X-Google-Smtp-Source: APXvYqy7HEtZGVh1e71gRhe7qnkK825b5iGwATkftMBwFsAn7HsJJGX0v49bEiysmdKDgT8RQo+7R7JyXx0cnTfvbIQ=
X-Received: by 2002:a2e:b607:: with SMTP id r7mr11552391ljn.100.1569887968468;
 Mon, 30 Sep 2019 16:59:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
In-Reply-To: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Mon, 30 Sep 2019 16:58:51 -0700
X-Gmail-Original-Message-ID: <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
Message-ID: <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
Subject: BUG: sk_backlog.len can overestimate
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp1.cs.Stanford.EDU
X-Scan-Signature: a1ccd6d2fa83ef575f7b7817ead66a1e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of 4.16.10, it appears to me that sk->sk_backlog_len does not
provide an accurate estimate of backlog length; this reduces the
usefulness of the "limit" argument to sk_add_backlog.

The problem is that, under heavy load, sk->sk_backlog_len can grow
arbitrarily large, even though the actual amount of data in the
backlog is small. This happens because __release_sock doesn't reset
the backlog length until it gets completely caught up. Under heavy
load, new packets can be arriving continuously  into the backlog
(which increases sk_backlog.len) while other packets are being
serviced. This can go on forever, so sk_backlog.len never gets reset
and it can become arbitrarily large.

Because of this, the "limit" argument to sk_add_backlog may not be
useful, since it could result in packets being discarded even though
the backlog is not very large.
