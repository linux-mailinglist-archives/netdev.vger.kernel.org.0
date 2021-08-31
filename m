Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46203FCE8C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbhHaUZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 16:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240997AbhHaUZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 16:25:44 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C59C061760;
        Tue, 31 Aug 2021 13:24:49 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id j18so570580ioj.8;
        Tue, 31 Aug 2021 13:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=V37xmJNOXbmKE+WjUdJI8ZGLV3Fc+43OHAropyNQRkw=;
        b=Pgdgd+mMtfn4TxGoH122YBQw5uUgT9h+hfuIfAxK+zkcS890XGw2h2hbf/YPYTCUxh
         vJR0ACRrT3kEq+Rm6u4QWPhpXKeT/6i+l9j3OvAV6fIpKvS/FlLTomiaRYuswO3lICHV
         Rw+aMOX0JVdxgu2XFio8vRKFoDC0tVmYsPD5HS38BLdmzMpDjfqow+Hxx/2f51yduMqo
         7UggpaXJHkgLMIwpMnwdPZSHDGZ1oxBSQytRdGnPkkCZhGh+7pZ8zZyRSe3tjGh63diH
         GTtZxjsqw8Up4aBSJasBf5FJLISKBL2wmheDf0sjcWlUxAMqJxG5FFGppDjSA136FaQ2
         mIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=V37xmJNOXbmKE+WjUdJI8ZGLV3Fc+43OHAropyNQRkw=;
        b=VHyniwR6rUA7z0elhEssnNJ3si61SBLBdnTbQ2WwbIzg//tkPNDPBSv1Jiy0ETjDD3
         eEHtTx9Vsunaf+sF/hvBCOs5FEFnCR07CcOUNSbZW8tHYYx4ITbf/AY9lQdKwewBiSk2
         ImN8Flxr69rNVUTXfmOiKMjgof9Wa1iivhiqRhbPdBxgQSZm3Xysqx30RkvhG/6nOi3J
         sMFydgOEUVUgloCh3jMVNU8fEZqsggsMOZV8j9wp1bknkms2OaKKaqOUX12Eoxi1mDsq
         iZo5/YuigeOGrq0hpOBYhUqhOmF6C/qMTKc4zYrrlAk3Q2E2C16UdZy/K6ufyjj2y9Xe
         fyyw==
X-Gm-Message-State: AOAM532r5mSFY52uY29MT1tOUnetSKCI7nK6aZykD0NvD4WlOdLY/qEN
        3zpli3bBAOVeh/SVa46R/v/PVwyUuXxjZXtORCx53+P+/WY=
X-Google-Smtp-Source: ABdhPJzVyQJcAfbjLVIj1aLhwkVTwk7uNhj2Xzc2hyEv+p3gLSixK8roQ0Gatw2fRKqX8/Bi3ggS+ykj0prRJlRPwYs=
X-Received: by 2002:a02:878f:: with SMTP id t15mr4439277jai.102.1630441488490;
 Tue, 31 Aug 2021 13:24:48 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Curtin <ericcurtin17@gmail.com>
Date:   Tue, 31 Aug 2021 21:23:53 +0100
Message-ID: <CANpvso5v0Lg4gDDAcBvRtHMKL5cZcpoL-RUWV_A+ogX4w2oRfw@mail.gmail.com>
Subject: TCP higher throughput that UDP?
To:     netdev@vger.kernel.org, linux-newbie@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guys,

I've been researching quantitatively various protocols QUIC, TCP, UDP,
SCTP, etc. on modern hardware. And some TLS, DTLS and plain text
variants of these protocols. I've avoided tuning kernel parameters so
much and focused more on adjusting what I can in user space on an out
of the box kernel, as if I was deploying on a machine where I did not
have root access (lets say an Android phone, even though these results
come from a laptop for simplicity). I did make a minor exception in
that I had to turn on SCTP.

I have a small client/server binary that implements bare bones
versions of TCP, UDP and SCTP. The server allows you to specify which
file clients will pull. And the client lets you specify which file to
write the pulled data to (often I use /dev/null here). I run both on
127.0.0.1 . I would have thought (obviously I was wrong) that UDP
would be faster, given no acks, retransmits, checksums, etc. as many
laymen would tell you. But on this machine TCP is faster more often
than not. This has been answered online with different answers of the
reasoning (hardware offload, how packet fragmentation is handled, TCP
tuned more for throughput, UDP tuned more for latency, etc.). I'm just
curious if someone could let me know the most significant factor (or
factors) here these days? Things like strace don't reveal much.
Changing buffer size to the read/write/send/recv system calls alters
things but TCP seems to still win regardless of buffer size.

Another question, I detect the UDP client has finished by checking for
a final (unsigned char) -1 byte, very error-prone of course. Is there
a better way to detect when a simple UDP client should stop trying to
pull/read/receive data, that you've seen or is commonplace?

If my code is too simplistic and there's one or two setsockopt's etc.
that might be interesting to add, my ears are open.

Feel free to pull this repo and run this script and take a quick look
at the few lines of code if needs be (currently pushing, at an airport
might be slow, should be commit around time of this email):

https://github.com/ericcurtin/DTLS-Examples

The two files relevant:

src/script.sh  src/udp-tls.c

To run my test case:

cd src; ./script.sh

I'd appreciate some thoughts from the gurus :)

My hardware:

ThinkPad-P1-Gen-3
CPU: i7-10850H
RAM: 32GB

Kernel version:

$ cat /etc/*release | head -n2; uname -r
Fedora release 34 (Thirty Four)
NAME=Fedora
5.13.12-200.fc34.x86_64

Is mise le meas/Regards,

Eric Curtin

Check out this charity that's close to my heart:

https://www.idonate.ie/fundraiser/11394438_peak-for-pat.html
https://www.facebook.com/Peak-for-Pat-104470678280309
https://www.instagram.com/peakforpat/
