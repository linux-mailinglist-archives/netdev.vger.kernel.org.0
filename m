Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D9F5373AE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 05:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiE3DQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 23:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiE3DQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 23:16:24 -0400
Received: from corp-front10-corp.i.nease.net (corp-front11-corp.i.nease.net [42.186.62.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC34A4BB88;
        Sun, 29 May 2022 20:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=3ZtQG
        plpK1TUOtshd/f0IPODZV9We7sq8TM2GN3EieU=; b=A7OuLVkRtBPo/LvMY8qLh
        zvlX3RenAztIQ2UlyMYSk/Ar/zUuLXhYSLBqghk33CuxKLx7zmKvVajeXDoukc1m
        17p7/0pXooZqLLrGJNCocxuu4/aQl+lidQstnAjmmIPlnrYhShnMvFG1tAHQCQN6
        tBQhAU8gVxaqsEJLXT2th0=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front11-corp.i.nease.net (Coremail) with SMTP id aYG_CgA3UmT0NpRiZmklAA--.15991S2;
        Mon, 30 May 2022 11:16:04 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com,
        tonylu@linux.alibaba.com
Subject: SMC-R problem under multithread
Date:   Mon, 30 May 2022 11:16:04 +0800
Message-Id: <20220530031604.144875-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: aYG_CgA3UmT0NpRiZmklAA--.15991S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWfXFWxXw1rKF4xKw1xKrg_yoWkCrb_WF
        4kGF1UA3y3JrWIgw4Ivr10yrZaqay5Cwn8Z34kKr10k3ykXwnxCFZ5X393Xa1kGF4Fkrn0
        gwn0vrZrtw1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbJkYjxAI6xCIbckI1I0E57IF64kEYxAxM7k0a2IF6w4xM7kC6x80
        4xWl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14
        AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv2
        0xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2z2
        80aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC
        6x9vy-n0Xa0_Xr1Utr1kJwI_Jr4le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCE34x0Y4
        8IcwAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2
        jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YV
        CY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24l7I0Y64k_MxkI7II2jI8vz4vEwIxGrwCF
        04k20xvY0x0EwIxGrwCF72vEw2IIxxk0rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7vE0w
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
        jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
        ZFpf9x07jD_-PUUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQATCVt763voNAAPs8
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi experts,

  I recently used memcached to test the performance of SMC-R relative to TCP, but the results 
  are confusing me. When using multithread on the server side, the performance of SMC-R is not as good as TCP.
    
  Specifically, I tested 4 scenarios with server thread: 1\2\4\8. The client uses 8threads fixedly. 
  
  server: (smc_run) memcached -t 1 -m 16384 -p [SERVER-PORT] -U 0 -F -c 10240 -o modern
  client: (smc-run) memtier_benchmark -s [SERVER-IP] -p [SERVER-PORT] -P memcache_text --random-data --data-size=100 --data-size-pattern=S --key-minimum=30 --key-maximum=100  -n 5000000 -t 8
  
  The result is as follows:
  
  SMC-R:
  
  server-thread    ops/sec  client-cpu server-cpu
      1             242k        220%         97%
      2             362k        241%        128%
      4             378k        242%        160%
      8             395k        242%        210%
      
  TCP:
  server-thread    ops/sec  client-cpu server-cpu
      1             185k       224%         100%
      2             435k       479%         200%
      4             780k       731%         400%
      8             938k       800%         659%                   
   
  It can be seen that as the number of threads increases, the performance increase of SMC-R is much slower than that of TCP.

  Am I doing something wrong? Or is it only when CPU resources are tight that SMC-R has a significant advantage ?  
  
  Any suggestions are welcome.


Thanks & Regards,
Yacan.

