Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B8F5ABA5
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 16:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfF2OEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 10:04:37 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:35291 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfF2OEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 10:04:37 -0400
Received: by mail-lf1-f41.google.com with SMTP id a25so5844426lfg.2
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 07:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IOMvn5s16JfLezM9dmVJwlwUGEl64bjMjKpv3JNIDgk=;
        b=Nk0FUQNx/CtB4Yi2TpYRQcYowrPmBDBsoSXU8cVVLxI/kCw20pZMR83Is8g0LnfVvO
         Y2dDk119NBCe7b9HCSqZVVCVADARaq9NzBz1OXQHJxQ8APLvlDLFwlGllYAJqruu9b6r
         HYgYJaMuHcgUA4uptw2aSHio+zOF6kxXG/WLfn+Tx9jiZ3Je7JXcspwQn4ge6XD0kpIP
         zbr04/h1CMQ2UeCv8GHd21A9U58Ra8CrRW2q1QndpGM/OCLT4x0pUK8aaYQSSKXB33Pb
         TGZyJkz3nkmIStTykOSA9CauynHPOhcOBxI5YQTrYcejMiP0fNmRez/H8TIDozlLW2P1
         WE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IOMvn5s16JfLezM9dmVJwlwUGEl64bjMjKpv3JNIDgk=;
        b=TOsPJnajHE9DkeuFv53Oyhh/NGaqxIHzhldr86/EN9dSFAUZatj5tTbWrzTq/6tMny
         c7LjR1CTzMMrv6vB0TS8fVSNWKG2RCc00MQSUmQIdqRqJpcyVKu8lgu9JpslGMWaz0b2
         eyYdqkl68cBc+tgvpzTiLuUU7okMHtHUoR/PSQis052zq+jk+pYG6NzT/pJcTagK1OGT
         duWTA1/KViQP4T1UIXKkMXQ20DrbA4t939Bv0CSCV/Fv85owkPPO7qTq7JDDgyA2CKE9
         VIt9XclerhpShgigMoK1JpiHK/o1CUA+IP0V3vJxORIpSF9YKtl+2cQ5yDCgCgGsTovs
         t2Lw==
X-Gm-Message-State: APjAAAWzHUigWkCGACKAW0U/dSN1UO7KkO+k1ssbJJWagE0f6CmgAD27
        1kXRCXj+MLyVf+mDJAeItcveLs5jMJm5IrjoXS395RWn
X-Google-Smtp-Source: APXvYqzQnOZMNmyz4OWjfScCqAWBDfY1DBib5SzZdYkEJYQe6eDVQx5eWJNTEc7T9mY0BiId7xXsQPcP10AgNKClmSI=
X-Received: by 2002:a19:c383:: with SMTP id t125mr7686960lff.89.1561817074999;
 Sat, 29 Jun 2019 07:04:34 -0700 (PDT)
MIME-Version: 1.0
From:   Aks Kak <akskak2012@gmail.com>
Date:   Sat, 29 Jun 2019 19:34:21 +0530
Message-ID: <CAAg6XZOVbPexui=MZC6QaL1-4e8SL6Z_z8S0+B6YAzSpgf8t8Q@mail.gmail.com>
Subject: Proxy arp for non-overlapping subnets on an interface without
 assigning IP aliases
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a linux box with 2 interfaces with following IPs
eno1 : 10.1.1.0/24
eno2 : 192.168.2.0/27

I want to use network 10.3.3.0/25 as virtual IPs for 192.168.2.0/25
i.e. I will be doing DNAT using NETMAP target of IPTABLES.

DNAT and NETMAP, etc. is not the issue.

For my requirement to work, main thing is who (or how) will give arp
replies for 10.3.3.0/27 !!!
I have 2 ways of achieving this:
1. Create all 126 IPs 10.3.3.1 - 10.3.3.126 as alias IPs on eno1. I
want to avoid it.
2. Use proxy arp for entire subnet 10.3.3.0/25 on eno1 but this
require having atleast one IP from this subnet to be created as IP
alias on eno1, say 10.3.3.1/25. However, my concern is that this
10.3.3.1, as it has been assigned to eno1,may be used by mistake to
listen for any service, etc. or ping, etc. which otherwise I would
have to control using iptables rule set. I totally want to avoid it.

So, my query is how to do proxy arp for 10.3.3.0/25 on eno1 without
assigning 10.3.3.1/25 to eno1???
