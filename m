Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D68219D67
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGIKRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGIKRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 06:17:25 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C960BC061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 03:17:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l17so1236903wmj.0
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 03:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=afDF9tYQy3W+Uj2Se1N0w02pg9VfKGxHoSqKW9keUYE=;
        b=uL/2pxzYB9KrLWol1bKSNqPDV03Ru7cM7TwwJmxzMgSNn6pAb2KMLSBgA7Y9z7Skmr
         VAejBngPEtrDN158Yo0kic0rmcMlst5hA1pYM2x8tlhJY9moBJme4Ny1eSAt29aw+u7N
         0h99YgwOXSlrrolzvwQpq1pcmPdkWs7tODU6SIyqDakBXK3D4k69Y32l8dsLLRiusAEM
         uYAy1IgedsFEOkfuZEJzRKss8n809/TWjLyEuuqSNWD8Ts0qvqoK368Jxocs1xaTn2w5
         RXCD6xLXairxH5c7AHMsIUQ2ta7QBWwoc3xXlJNn5jjSDV768FQY9wSEjcW/p9gQc/gs
         3xNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=afDF9tYQy3W+Uj2Se1N0w02pg9VfKGxHoSqKW9keUYE=;
        b=mXJtTl4nPYoRESvr7YCP8cnFzILtJhp3oYlr+Rhly4qQOBn8sfffNlGvPH448umpiH
         1S0NWEQp4FqDjWbfp7avYbV6NMOIhKlPSY4eOw5o9S5VilcERUrWGdJBj1YNCkrQ5SMh
         1VDHjhkTWlsXIjzTcgKctCynBMjOftxwx3l0gc9ehMjeiExwcWz6iQowEdEgaAUFXzU4
         ha5D7OBP1vnQ0qPX2vtGc1S2c8pAWkZZiJyBNk0kHzHhgkgqvf9qaulibKd9W1WLuG8U
         wFPKso5eca2mD55RYPiwRyvLsjqbVGeX4mcunVXuolg++Y2UDs2b6LWqXN1673Zh0s6h
         MIYg==
X-Gm-Message-State: AOAM532G9PTg26kmnsRwH9uZRIdtEkSfb2/Yi0H41cgTaK2Uqexl0aOm
        +vFNyCayVQ2ZAoAYsFWlVXg=
X-Google-Smtp-Source: ABdhPJyflSvMQC0ay3MnWryIPsPVF8inyPKPl75vmPTGngasnxjQ0xW8sdx4AwzDZvkZq2cfkM7ppg==
X-Received: by 2002:a1c:b6c3:: with SMTP id g186mr14037765wmf.135.1594289843358;
        Thu, 09 Jul 2020 03:17:23 -0700 (PDT)
Received: from localhost.localdomain ([77.139.6.232])
        by smtp.gmail.com with ESMTPSA id o21sm3988607wmh.18.2020.07.09.03.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 03:17:22 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 0/2] xfrm interface: use hash to store xfrmi contexts
Date:   Thu,  9 Jul 2020 13:16:50 +0300
Message-Id: <20200709101652.1911784-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When having many xfrm interfaces, the linear lookup of devices based on
if_id becomes costly.

The first patch refactors xfrmi_decode_session() to use the xi used in
the netdevice priv context instead of looking it up in the list based
on ifindex. This is needed in order to use if_id as the only key used
for xi lookup.

The second patch extends the existing infrastructure - which already
stores the xfrmi contexts in an array of lists - to use a hash of the
if_id.

Example benchmarks:
- running on a KVM based VM
- xfrm tunnel mode between two namespaces
- xfrm interface in one namespace (10.0.0.2)

Before this change set:

Single xfrm interface in namespace:
$ netperf -H 10.0.0.2 -l8 -I95,10 -t TCP_STREAM

MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.0.2 () port 0 AF_INET : +/-5.000% @ 95% conf.  : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

131072  16384  16384    8.00      298.36

After adding 400 xfrmi interfaces in the same namespace:

$ netperf -H 10.0.0.2 -l8 -I95,10 -t TCP_STREAM

MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.0.2 () port 0 AF_INET : +/-5.000% @ 95% conf.  : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

131072  16384  16384    8.00      221.77   

After this patchset there was no observed change after adding the
xfrmi interfaces.

Eyal Birger (2):
  xfrm interface: avoid xi lookup in xfrmi_decode_session()
  xfrm interface: store xfrmi contexts in a hash by if_id

 net/xfrm/xfrm_interface.c | 52 +++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 19 deletions(-)

-- 
2.25.1

