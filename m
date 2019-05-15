Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21DFC1FB4B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 21:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfEOT4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 15:56:45 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]:38371 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfEOT4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 15:56:44 -0400
Received: by mail-qk1-f173.google.com with SMTP id a64so813152qkg.5
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appleguru.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=ReVUZJquNh3ZzRIL0hn5F4n1AxAwgMI8r6Dj77/5CUs=;
        b=cWcmbIHigDOoqD+mu4ohQS0CWZgKkrHE+Ngqz9aQZV8yRRrwZBdyd5qt/4aW8Z3X47
         MwWzrUaAaYorWCozq8DG0nwfZ/4b/rED3Og4nACqsPstFvfXRfyqyQ/Ns33TjWW10Mr/
         eMsjgN1RCCw++1CxUPqGS0Tg0hSqDMJHNZ3LI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ReVUZJquNh3ZzRIL0hn5F4n1AxAwgMI8r6Dj77/5CUs=;
        b=NL9XE55fskx04rQYKyrFzznh61ioWs9bQejkd36J4YB4ghBdB+4aJ39hMCbq3/D+pH
         AWdExWHuT5EwD2z7sQfvt9/Kja214fNRhXcHLdD6hLCTQregz97qF5lcVmOGl+VVmn4U
         AxHEoVZDHBCKCqJt9PzLyU7aksw4KAdhzGTmtWTqAFn+s6aAFIdPiebFX/HzuwljGer+
         zfDrAGlYcWu+S93B1jsEcSueidQP4ykgh2MXkAITcX+bLSeTc2b0QYpgtCM2dwicaKDm
         zR+XTsqwHNuBymStd2rKKai3HxBa3eYg1dFTzgoA+5X2BdU5vhPkDjYRQRATAzGeVzYu
         p8Qg==
X-Gm-Message-State: APjAAAVYeSLooeit9kMTPvsoNb8zNhzv7snYsYfUbcEn5D1r9UwgsVCQ
        drukCYEkJcq4ytywqlgX8OEKfcarwEs=
X-Google-Smtp-Source: APXvYqyV+QhmMpA+4G6mr4gRLBC6/1tDLoyQk8kQkEbpT+ofsjqAqpKUEbozQ/rV091ZgMV14NtYag==
X-Received: by 2002:a37:aac6:: with SMTP id t189mr35981538qke.158.1557950203893;
        Wed, 15 May 2019 12:56:43 -0700 (PDT)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com. [209.85.160.174])
        by smtp.gmail.com with ESMTPSA id g41sm1527165qte.79.2019.05.15.12.56.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:56:43 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id k24so1172692qtq.7
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 12:56:43 -0700 (PDT)
X-Received: by 2002:a0c:c781:: with SMTP id k1mr35926126qvj.133.1557950202891;
 Wed, 15 May 2019 12:56:42 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Urban <adam.urban@appleguru.org>
Date:   Wed, 15 May 2019 15:56:32 -0400
X-Gmail-Original-Message-ID: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
Message-ID: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
Subject: Kernel UDP behavior with missing destinations
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have an application where we are use sendmsg() to send (lots of)
UDP packets to multiple destinations over a single socket, repeatedly,
and at a pretty constant rate using IPv4.

In some cases, some of these destinations are no longer present on the
network, but we continue sending data to them anyways. The missing
devices are usually a temporary situation, but can last for
days/weeks/months.

We are seeing an issue where packets sent even to destinations that
are present on the network are getting dropped while the kernel
performs arp updates.

We see a -1 EAGAIN (Resource temporarily unavailable) return value
from the sendmsg() call when this is happening:

sendmsg(72, {msg_name(16)={sa_family=AF_INET, sin_port=htons(1234),
sin_addr=inet_addr("10.1.2.3")}, msg_iov(1)=[{"\4\1"..., 96}],
msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 EAGAIN (Resource
temporarily unavailable)

Looking at packet captures, during this time you see the kernel arping
for the devices that aren't on the network, timing out, arping again,
timing out, and then finally arping a 3rd time before setting the
INCOMPLETE state again (very briefly being in a FAILED state).

"Good" packets don't start going out again until the 3rd timeout
happens, and then they go out for about 1s until the 3s delay from ARP
happens again.

Interestingly, this isn't an all or nothing situation. With only a few
(2-3) devices missing, we don't run into this "blocking" situation and
data always goes out. But once 4 or more devices are missing, it
happens. Setting static ARP entries for the missing supplies, even if
they are bogus, resolves the issue, but of course results in packets
with a bogus destination going out on the wire instead of getting
dropped by the kernel.

Can anyone explain why this is happening? I have tried tuning the
unres_qlen sysctl without effect and will next try to set the
MSG_DONTWAIT socket option to try and see if that helps. But I want to
make sure I understand what is going on.

Are there any parameters we can tune so that UDP packets sent to
INCOMPLETE destinations are immediately dropped? What's the best way
to prevent a socket from being unavailable while arp operations are
happening (assuming arp is the cause)?
