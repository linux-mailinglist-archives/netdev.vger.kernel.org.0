Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D92E6B4BF0
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCJQFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjCJQFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:05:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D07653719
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678464096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0xUmcNvm9OhI6gvTwqauUicJ3Galf9wGdney4qbqfVc=;
        b=Cj3YAPtpnjIr4uY4SiAATA9jpJXPtuk/SLzwb/ak7C27MmLLvv0uZD/pS7T4mBzF9PyAw9
        wqwxKvl6GN0OjaAjI1NaHlBrY3F8lMXHEvowmaUjr4qqG0xgzyc29WQhF6PsoUazvp5Wl6
        8HtrZDjniYiCnlDNvosdiQiGKZm9nVE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-WUWJrYo9MlSBp5PLK80QDw-1; Fri, 10 Mar 2023 11:01:35 -0500
X-MC-Unique: WUWJrYo9MlSBp5PLK80QDw-1
Received: by mail-wr1-f72.google.com with SMTP id y11-20020a056000168b00b002ce179d1b90so1153978wrd.23
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678464094;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0xUmcNvm9OhI6gvTwqauUicJ3Galf9wGdney4qbqfVc=;
        b=Eccwy4hjFdqSq2OWmrmWqggp1d7fCova1jZucJ2fFzSA/mC01Z/BLc/TNktJIMUSmU
         34hdoUxVkzJAd3WWlEw2otGz0IJQCszFuyi+XsizAGxAUeqBlTeuPUSnFLbzB9tJ/Tt4
         Wru7ORRYDlnvK8p8k+8b7VEi33bPbRGPtjnPjyhiUAa1mCcKihu3sFRajPSlMJk+APkJ
         yJzXrE6sMZnVwRYEQu8HZiLjhxP9h5auI03dDPRZZwkvNqzWpCd6s2qjaa04j2xy2JTe
         XOnxj6a+XXu7lYvbJOvSIGUKXGmkBQ/j1uRQQe5xeiPImhTT9Nnoo0qSghMpD+ihLYXM
         SoxQ==
X-Gm-Message-State: AO0yUKUA9W1Ec8gtZUcB8RpGThdVWXpWaag8D8IfxGlUNVD/wEUXENPu
        M40LH/ybLmAW8GO3vDPgUTj9QQK7BUNdR2dkLe9k0pTyn6fXtZ4/hneny3YK4xRNtkmUQaYDG5l
        6MBDHBK4mEvr3UNTmszalygq+
X-Received: by 2002:a05:600c:1c8d:b0:3df:d8c5:ec18 with SMTP id k13-20020a05600c1c8d00b003dfd8c5ec18mr3277841wms.13.1678464093914;
        Fri, 10 Mar 2023 08:01:33 -0800 (PST)
X-Google-Smtp-Source: AK7set8TykNev7d9AXrs/W7cNFl0qC1yRTdR8u3Il2ju5XgUGDpbh61KqtKbXx5Wxs36LiH+NFMs9w==
X-Received: by 2002:a05:600c:1c8d:b0:3df:d8c5:ec18 with SMTP id k13-20020a05600c1c8d00b003dfd8c5ec18mr3277811wms.13.1678464093647;
        Fri, 10 Mar 2023 08:01:33 -0800 (PST)
Received: from [192.168.188.25] ([80.243.52.134])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d40ce000000b002c5539171d1sm152743wrq.41.2023.03.10.08.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 08:01:33 -0800 (PST)
Message-ID: <e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com>
Date:   Fri, 10 Mar 2023 17:01:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
From:   Paul Holzinger <pholzing@redhat.com>
Subject: [REGRESSION] v6.1+ bind() does not fail with EADDRINUSE if dual stack
 is bound
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        martin.lau@kernel.org, kuba@kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

there seems to be a regression which allows you to bind the same port 
twice when the first bind call bound to all ip addresses (i. e. dual stack).

A second bind call for the same port will succeed if you try to bind to 
a specific ipv4 (e. g. 127.0.0.1), binding to 0.0.0.0 or an ipv6 address 
fails correctly with EADDRINUSE.

I included a small c program below to show the issue. Normally the 
second bind call should fail, this was the case before v6.1.


I bisected the regression to commit 5456262d2baa ("net: Fix incorrect 
address comparison when searching for a bind2 bucket").

I also checked that the issue is still present in v6.3-rc1.


Original report: https://github.com/containers/podman/issues/17719

#regzbot introduced: 5456262d2baa


```

#include <sys/socket.h>
#include <sys/un.h>
#include <stdlib.h>
#include <stdio.h>
#include <netinet/in.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
     int ret, sock1, sock2;
     struct sockaddr_in6 addr;
     struct sockaddr_in addr2;

     sock1 = socket(AF_INET6, SOCK_STREAM, 0);
     if (sock1 == -1)
     {
         perror("socket1");
         exit(1);
     }
     sock2 = socket(AF_INET, SOCK_STREAM, 0);
     if (sock2 == -1)
     {
         perror("socket2");
         exit(1);
     }

     memset(&addr, 0, sizeof(addr));
     addr.sin6_family = AF_INET6;
     addr.sin6_addr = in6addr_any;
     addr.sin6_port = htons(8080);

     memset(&addr2, 0, sizeof(addr2));
     addr2.sin_family = AF_INET;
     addr2.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
     addr2.sin_port = htons(8080);

     ret = bind(sock1, (struct sockaddr *)&addr, sizeof(addr));
     if (ret == -1)
     {
         perror("bind1");
         exit(1);
     }
     printf("bind1 ret: %d\n", ret);

     if ((listen(sock1, 5)) != 0)
     {
         perror("listen1");
         exit(1);
     }

     ret = bind(sock2, (struct sockaddr *)&addr2, sizeof(addr2));
     if (ret == -1)
     {
         perror("bind2");
         exit(1);
     }
     printf("bind2 ret: %d\n", ret);

     if ((listen(sock2, 5)) != 0)
     {
         perror("listen2");
         exit(1);
     }

     // uncomment pause() to see with ss -tlpn the bound ports
     // pause();

     return 0;
}

```


Best regards,

Paul

