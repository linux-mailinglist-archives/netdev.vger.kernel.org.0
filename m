Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C535424F4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406016AbfFLMDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:03:46 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:32875 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405097AbfFLMDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:03:46 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so4133873wme.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=PghWUJ1T7m6l2fopcdNlUfUVcMaH9jtl/tLnkpqSCLs=;
        b=MM9cSFm14rIL0nK2/Xf4M6ZLXW5Ypd1Vd7XyYaDsqPjoIYobjfmf3Jl/cueLnpt0yC
         F+lUzg25EY+bnc91kdxBxyGI4ZQtxAWn+5GWh2WQr/d8ZnEnHlpUjZTHkUEObClN9zDD
         PeikOcPfOApcdABmov3QaXJdZYuNIDIBbRgt6OVIrJ70rZEj8vqH1h96iwMdIkHeSeCl
         glqrNIhpwVOPyfHgGAEw5L+fkXX7UEI9REiMtjI2vFFLQHfQ4bIAIoyLEMc/YG3gbIoK
         7/mbHIFf0BOYwRExuSWDT0r7webSDao7DbqwMoc+3bcm0x/4tVcY/6ptoxjXxsWRSG5A
         nrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=PghWUJ1T7m6l2fopcdNlUfUVcMaH9jtl/tLnkpqSCLs=;
        b=VOYtO8FUJvvPOUTPwMCjSHa5+bREO3OhD8i495suVgsnjTrTmRPoYTSO4//mUxNgnb
         1izxeYLK/ZPsJW9qoYmJrvBK2rdPev30xXznJUJh7nA9GlvDocn7jldwtfLu0F7o6HrM
         AJP/EYbFZo+EEzpyxh8EtZcuPucOPle2ZHy+KTpsQkroVUAfMXV7s/JdAXRkqJkwDjkw
         Z9tOhGJGegmPLpiZ6xYhnC91dIeS85d4+k28YNMOH7CGZT0CJALZodpuv4Hzydz0+IIr
         7uh4FLUBfAPRHR5vKXxToZhZByNuakR+iH3UdRrZASmswCe3saEUbu9aYD9Wf2I/mm3/
         d++Q==
X-Gm-Message-State: APjAAAWMI0sdviso/ZQsaVIl32JqTTnNg1DEPEUPXyMH5m8Z6h0oXTrr
        yN9wg/5dbLuukEKMfOsKjoqKqAmmP8k=
X-Google-Smtp-Source: APXvYqyphOjFjLqQTXR+SSBW2W090+4uDNiXC+9KzAGj6lhYaqt5HegOzlxlu05/b9+tsKeb/GPE/A==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr21869395wmj.155.1560341022319;
        Wed, 12 Jun 2019 05:03:42 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id o15sm22886334wrw.42.2019.06.12.05.03.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 05:03:41 -0700 (PDT)
Date:   Wed, 12 Jun 2019 14:03:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     vladbu@mellanox.com, pablo@netfilter.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, mlxsw@mellanox.com, alexanderk@mellanox.com
Subject: tc tp creation performance degratation since kernel 5.1
Message-ID: <20190612120341.GA2207@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

I came across serious performance degradation when adding many tps. I'm
using following script:

------------------------------------------------------------------------
#!/bin/bash

dev=testdummy
ip link add name $dev type dummy
ip link set dev $dev up
tc qdisc add dev $dev ingress

tmp_file_name=$(date +"/tmp/tc_batch.%s.%N.tmp")
pref_id=1

while [ $pref_id -lt 20000 ]
do
        echo "filter add dev $dev ingress proto ip pref $pref_id matchall action drop" >> $tmp_file_name
        ((pref_id++))
done

start=$(date +"%s")
tc -b $tmp_file_name
stop=$(date +"%s")
echo "Insertion duration: $(($stop - $start)) sec"
rm -f $tmp_file_name

ip link del dev $dev
------------------------------------------------------------------------

On my testing vm, result on 5.1 kernel is:
Insertion duration: 3 sec
On net-next this is:
Insertion duration: 54 sec

I did simple prifiling using perf. Output on 5.1 kernel:
    77.85%  tc               [kernel.kallsyms]  [k] tcf_chain_tp_find
     3.30%  tc               [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     1.33%  tc_pref_scale.s  [kernel.kallsyms]  [k] do_syscall_64
     0.60%  tc_pref_scale.s  libc-2.28.so       [.] malloc
     0.55%  tc               [kernel.kallsyms]  [k] mutex_spin_on_owner
     0.51%  tc               libc-2.28.so       [.] __memset_sse2_unaligned_erms
     0.40%  tc_pref_scale.s  libc-2.28.so       [.] __gconv_transform_utf8_internal
     0.38%  tc_pref_scale.s  libc-2.28.so       [.] _int_free
     0.37%  tc_pref_scale.s  libc-2.28.so       [.] __GI___strlen_sse2
     0.37%  tc               [kernel.kallsyms]  [k] idr_get_free

Output on net-next:
    39.26%  tc               [kernel.vmlinux]  [k] lock_is_held_type
    33.99%  tc               [kernel.vmlinux]  [k] tcf_chain_tp_find
    12.77%  tc               [kernel.vmlinux]  [k] __asan_load4_noabort
     1.90%  tc               [kernel.vmlinux]  [k] __asan_load8_noabort
     1.08%  tc               [kernel.vmlinux]  [k] lock_acquire
     0.94%  tc               [kernel.vmlinux]  [k] debug_lockdep_rcu_enabled
     0.61%  tc               [kernel.vmlinux]  [k] debug_lockdep_rcu_enabled.part.5
     0.51%  tc               [kernel.vmlinux]  [k] unwind_next_frame
     0.50%  tc               [kernel.vmlinux]  [k] _raw_spin_unlock_irqrestore
     0.47%  tc_pref_scale.s  [kernel.vmlinux]  [k] lock_acquire
     0.47%  tc               [kernel.vmlinux]  [k] lock_release

I didn't investigate this any further now. I fear that this might be
related to Vlad's changes in the area. Any ideas?

Thanks!

Jiri
