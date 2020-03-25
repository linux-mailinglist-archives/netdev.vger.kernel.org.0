Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D144191E25
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 01:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgCYAfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 20:35:42 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:34085 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgCYAfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 20:35:42 -0400
Received: by mail-qk1-f175.google.com with SMTP id i6so765903qke.1
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 17:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2r6qbFQtuYRCGbrxB0GVTBY07JURTErDRxEQnvPs7aU=;
        b=D7upEJtcx0ymF4+PfccI+TKu/J7E+IOmG/qLGUoKEyhJUEUICGDT9QzSBRib255dKi
         s6LlQ+X3JwRAi/R9cx5vEENPOpJ0/1rZcgK7lCJf+lCwKdIa/OjS+cPra6bIIg0ehURJ
         GsS97S9K+Txl3J2e8UhhZRZJDnUSVmP0tHciGdD9Vf/RSmxn+SIRYWhEcQmwWw1/nI50
         Ag7FkVumE1GeCqkI0RukXMAsDrV8ZAX6miKgK/wvThKSnnCt/vYFp97TBX5Tys0qfeKy
         rHnVDrwXmqJoET75qLJZ+fvASbhzqgQJeN2Ic6KrOn+gLIsn7f8AS8nh8gDGWmV/Gqb/
         mcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2r6qbFQtuYRCGbrxB0GVTBY07JURTErDRxEQnvPs7aU=;
        b=DnuvxTE5PzadGNJBfljq1ZbsHedE58SNz046NWnjbHm3z9mFxZhhhaJ4UpueT1nKXn
         wG1LW02Nw8S3Y63zhn/YAvH3jfmYEfqDXfEklbWqUTuVwjUsmPZjjJIJvYRBInYFvMNE
         0Fxsc0F/8xzYn9eoGRWfwMsthZ7yEENbWyxWLPZcMhYJIB2x+NlKAtrk18WIRVDXJK+N
         VuMqxkBHU89OWyJTSMYGwaA4V2jqu4D5njxeTxQffwuzw44cfN97ginHkzZo8t5Np72K
         1sv9o/xNlCOQspZlsUaLk/2zVFhsKvHBg3on8zD+Ms+Iy+KljhkzIvS3ILzFWk6Owfbu
         M7WA==
X-Gm-Message-State: ANhLgQ3ySZ+jE+GlYgEBYZyOeotNmtE8PcwMCZa5td9EeTonxlmeRMxb
        LS/7k0agrfQiyezYfwGTBNntxxtiCL64eTZEmFkyEjvC
X-Google-Smtp-Source: ADFU+vtEhIgpFMqpnEcxumTvMp5sNrYo8tD4iig0sljQSwVHWxS5NxkF6Gl18zKopa1hJvXq1yjIDxpbHjJOpGCAzrI=
X-Received: by 2002:a05:620a:123c:: with SMTP id v28mr598269qkj.478.1585096539086;
 Tue, 24 Mar 2020 17:35:39 -0700 (PDT)
MIME-Version: 1.0
From:   Eduard Guzovsky <eguzovsky@gmail.com>
Date:   Tue, 24 Mar 2020 20:35:25 -0400
Message-ID: <CAJJdyE1THwu70UrErbQQgmDPRrBjapQLdgv-epgEXMTyfRoQEA@mail.gmail.com>
Subject: Significant performance degradation after updating i40e driver vrom
 version 2.1.14-k to 2.3.2-k
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have two Linux boxes connected via dedicated 40Gb link, both using
Intel XL710 card. I ran a unidirectional single tcp stream performance
tests using iperf2.

In these tests Box 1 acts as a client (sender) and Box 2 as a server
(receiver). No special ethtool adjustments were made on ethernet
devices - I was using the defaults.

In all the tests nothing changed in the Box 2 setup. It has Intel Xeon
E5-1650 v3 @ 3.50GHz with 64 GB of memory. It ran CentOS 6, kernel
version  2.6.32-754.9.1.el6, i40e driver version 1.5.10-k.

Box 1 has Intel Xeon CPU E3-1230 v3 @ 3.50GHz with 32 GB of memory. In
the first test Box 1 ran CentOS 7, kernel version 3.10.0-862.11.6.el7,
i40e driver version 2.1.14-k. In this test I got 39.6 Gb/sec transmit
rate.

In the second test Box 1 software got upgraded to kernel version
3.10.0-957.1.3.el7, i40e driver version 2.3.2-k. After the upgrade
transmit performance dropped to about 20Gb/sec.

Apart from the performance, a significant change between these two
test runs was the ethernet device interrupt rate. In the first test
(showing good performance) I got about 20K interrupts/sec, in the
second test (showing bad performance) - about 11K interrupts/sec. It
looked like something changed in the adaptive-tx interrupts mechanism.
I turned off adaptive-tx and played with tx-usecs value and was able
to get transmit performance to about 35 Gb/sec.

I then noticed that adaptive ITR algorithm changed significantly
between 2.1.14-k and 2.3.2-k versions of the i40e driver. Here is the
name of patch: "i40e/i40evf: Add support for new mechanism of updating
adaptive ITR" (commit a0073a4b8b5906b2a7eab5e9d4a91759b56bc96f). It is
a very cool new algorithm, but I think that in my particular scenario
it caused the slowdown.

What's the best way to get the performance back? Is it possible to
adjust (without modifying the source code) the adaptive ITR
parameters, so that I could try to find suitable values for my case
and get the performance back? Or is disabling adaptive ITR the only
way to go?

Thanks,

-Ed
