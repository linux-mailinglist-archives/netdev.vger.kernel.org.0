Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B643D36030F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhDOHQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhDOHQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:16:20 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757E5C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:15:56 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id f195-20020a1c1fcc0000b029012eb88126d7so1793742wmf.3
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=pR1DanzmoO0Ir0pgzqc6i+3eMn5/gcSB7Ikn+ECOBeM=;
        b=URKmQ1RCsMLJ0CorX89btRWwoxqXwXrx4Q4xvxweJmb4b3MzK2IPBC13rIyVZFELdn
         GNtK280x5sAkIIER+TH6b3+BhRXeHkRYFy2xebNKmBkJSg2xzZQGKoyLRPWrPn253QAn
         OzDn29MJ6t5oMrRaBOCWi6T4Fx7pSXGukz46WwZMMKCpqK2fkFPA09KDdyV5zhjxZiyf
         ofGANF9TkomZvXVnbry51CV7lROUu71Ae8Zr5BkGlF/XcqXsaLBZVPcr1RqWJ78V0NCx
         qSfQobHzOe1lptee/5UXAghEnnYxYeh+hV6BDgfjCjMCQvYYm/1K/V1UE4VlJjd2qvC5
         K6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pR1DanzmoO0Ir0pgzqc6i+3eMn5/gcSB7Ikn+ECOBeM=;
        b=K+h+Ewpi55tKx2b9fF9c5z9JOsMfIHWokx5pOZduPPaGgaLs7L5t5mf0KDP693+6dq
         0OJuPLA/bVvYYN/aviJtBfn5Nez/jmS0EHOyXHAB2sFWUHy85+AMaoKheBm4SAB2pH9L
         mn+ekJSnRmJO+f5qH4/ihr9Mv8jQSzJCack3bMk5+qBBJdBv6SUBMKW1b1++cg+M6kW5
         ZUlWwhnqILfMIdPlTSEPmT0pOtYfHxkdJdUp3l3epzW+DJGIs0h0EeK65x3q8jhT6Toh
         Ck3xQJuiPD7HR+FyXNuTUbFViAqdKgwiga+FqAoVCZO6OizyyC/qjb6R+Y/G8hf2VHuy
         jWmA==
X-Gm-Message-State: AOAM530yOtEjws30hREUdt22W51w+HXBv2N1/+t0j49mqW9ZIU78gDq/
        YYg8+nBxgw89Bb5HvHP6CCI++J7UpJSpu2efNkvE7h8zrGpWIA==
X-Google-Smtp-Source: ABdhPJxL0duBWewB7zAcqg7UyFHeBoenb3J5irQF/O9uNTXLQiMcshOEm5tYOHEkMVpEN8yTyHHHKg0t1v9T7MuBqRY=
X-Received: by 2002:a7b:ca44:: with SMTP id m4mr1626092wml.103.1618470955021;
 Thu, 15 Apr 2021 00:15:55 -0700 (PDT)
MIME-Version: 1.0
From:   Bala Sajja <bssajja@gmail.com>
Date:   Thu, 15 Apr 2021 12:45:44 +0530
Message-ID: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
Subject: Different behavior wrt VRF and no VRF - packet Tx
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When interfaces are not part of VRF  and below ip address config is
done on these interfaces, ping with -I (interface) option, we see
packets transmitting out of the right interfaces.

 ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
 ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8

 ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
 ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s8

When interfaces are enslaved  to VRF  as below and ip are configured
on these interfaces, packets go out of one  interface only.

 ip link add MGMT type vrf table 1
 ip link set dev MGMT up
 ip link set dev enp0s3 up
 ip link set dev enp0s3 master MGMT
 ip link set dev enp0s8 up
 ip link set dev enp0s8 master MGMT
 ip link set dev enp0s9 up

 ip addr add 2.2.2.100 peer 1.1.1.100/32 dev enp0s3
 ip addr add 2.2.2.100 peer 1.1.1.100/32  dev enp0s8

 ping 1.1.1.100    -I  enp0s3 , packet always goes out of  enp0s3
 ping 1.1.1.100    -I   enp0s8, packet always goes out of  enp0s3


Regards,
Bala.
