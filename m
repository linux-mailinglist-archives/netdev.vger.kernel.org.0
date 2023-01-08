Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687906616CB
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 17:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjAHQmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 11:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjAHQmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 11:42:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4462BDEEF
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 08:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673196091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KZPrrHbMqSgKL8BLXVN4N8Vx5I+kAphM9nctHUJQUi8=;
        b=SqqjTneUL79n+Iz1R164jM0I4Qo5bl0l85rtas1OkJOai7PYLfVpmyZXZq+JQVF5YJBBcd
        pjBim0pmZprbcq7HdCsXoZtcOixZ3B+BDJNiT0bd5ld5nEQ86tMkSKC0J3RIRbAoA3URUJ
        JEhtmafkiEy407K14saDh5P9NuVvRxU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-231-fSscDs0WNLugwo9yoGRtsg-1; Sun, 08 Jan 2023 11:41:29 -0500
X-MC-Unique: fSscDs0WNLugwo9yoGRtsg-1
Received: by mail-qv1-f70.google.com with SMTP id nh4-20020a056214390400b004e36a91ecffso3990282qvb.19
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 08:41:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KZPrrHbMqSgKL8BLXVN4N8Vx5I+kAphM9nctHUJQUi8=;
        b=quGD8+eEEWGNYZuWk3JoW2oTchvou+u2BdyTw8OGIBGtCSHezTrmJ75euWauax/82+
         CcBOyrnPAQxbzR9e8fT8inWuuBKjQuY670wnbDVySoFgCXXhGo4qQXWqbjI6KZ6SqJuW
         8AclCrJsBDzbFTy9h6w6jpQ2W4O/zdkpoTncTF4G+HtyFVjRCJE2aKgt8ykW2qA5yO0E
         jXJusiTizEtpMlxha1GxAIoScxbw4k4b6AKreH5Ntbh+61VDyQoIdY6Ap+fi9UfVmnb/
         VNY06RzXU5kpfVZKS4dzvSNTCo4jqZVf5hAcuRY1f1q6sdSB/N6IRka4CMf0K4rXaIMb
         CTeg==
X-Gm-Message-State: AFqh2kpUUnW+6rPgTDah/R/qNkuUXCdUHAtVOAQ1Uhi4vUPWh7juecaT
        LsV4DOZZKJmcbqwNA6NstDfRwVx1n3PWLjkepnVW3jXZ53/RUOo1uEeCDv6VSkdtiL5EvnulWgG
        BSNfW7UuZPA4zzsSO
X-Received: by 2002:a05:6214:3713:b0:531:bb5a:3418 with SMTP id np19-20020a056214371300b00531bb5a3418mr44260856qvb.13.1673196089179;
        Sun, 08 Jan 2023 08:41:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvdyico4iBmiWuyPHZKh2g2tFBMAznUg0tI9GsdDN2jNUzKQ5otucYpEsWESNWm1Ub6TmeuzA==
X-Received: by 2002:a05:6214:3713:b0:531:bb5a:3418 with SMTP id np19-20020a056214371300b00531bb5a3418mr44260840qvb.13.1673196088944;
        Sun, 08 Jan 2023 08:41:28 -0800 (PST)
Received: from debian (2a01cb058918ce0098fed9113971adae.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:98fe:d911:3971:adae])
        by smtp.gmail.com with ESMTPSA id k19-20020a05620a415300b006feb0007217sm3925779qko.65.2023.01.08.08.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 08:41:28 -0800 (PST)
Date:   Sun, 8 Jan 2023 17:41:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias May <matthias.may@westermo.com>
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs
 when selftest restarted
Message-ID: <Y7ryNK2sMv+PC6xr@debian>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian>
 <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian>
 <81fdf2bc-4842-96d8-b124-43d0bd5ec124@alu.unizg.hr>
 <Y7rNgPj9WIroPcQ/@debian>
 <750cd534-1361-4102-67c5-2898814f8b4c@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <750cd534-1361-4102-67c5-2898814f8b4c@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 08, 2023 at 03:49:05PM +0100, Mirsad Goran Todorovac wrote:
> On 08. 01. 2023. 15:04, Guillaume Nault wrote:
> 
> > For some reasons, your host doesn't accept the VXLAN packets received
> > over veth0. I guess there are some firewalling rules incompatible with
> > this tests script.
> 
> That beats me. It is essentially a vanilla desktop AlmaLinux (CentOS fork)
> installation w 6.2-rc2 vanilla torvalds tree kernel.
> 
> Maybe DHCPv4+DHCPv6 assigned address got in the way?

I don't think so. The host sends an administratively prohibited
error. That's not an IP address conflict (and the script uses reserved
IP address ranges which shouldn't conflict with those assigned to regular
host).

The problem looks more like what you get with some firewalling setup
(like an "iptables XXX -j REJECT --reject-with icmp-admin-prohibited"
command).

> > I can probably help with the l2tp.sh failure and maybe with the
> > fcnal-test.sh hang. Please report them in their own mail thread.
> 
> Then I will Cc: you for sure on those two.
> 
> But I cannot promise that this will be today. In fact, tomorrow is prognosed
> rain so I'd better use the remaining blue-sky-patched day to do some biking ;-)

No hurry :)

> Anyway, I haven't received feedback from all submitted bug reports, so my stack
> is near the overload. However, I made the "make kselftest" complete on both boxes
> (and OSs of Debian and RH lineage), so I already feel some accomplishment :)
> 
> Maybe some issues will be fixed in today's release candidate, anyway.
> 
> Mirsad 
> 
> -- 
> Mirsad Goran Todorovac
> Sistem inženjer
> Grafički fakultet | Akademija likovnih umjetnosti
> Sveučilište u Zagrebu
>  
> System engineer
> Faculty of Graphic Arts | Academy of Fine Arts
> University of Zagreb, Republic of Croatia
> The European Union
> 

