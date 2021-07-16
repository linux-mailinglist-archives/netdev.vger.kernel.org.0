Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC693CB32B
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 09:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhGPHWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 03:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235173AbhGPHWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 03:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626419983;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LzRNYAtqYOTj/V0dAkfMc1jXJowVL1A+56TG4pOS/EU=;
        b=fjctUJQgKcVhDQ7xkQG9Xbw63bisfMBX1WY2l20rp4PaKuLCxoq3yRV6a3SNMOajA2Eh3p
        A9vDeQv9TTdyk4yn5dnxZS2e/FYvZ1yJZ8JLqDsmiiOH6O0tGug0hk0YHE5hSXrBxCWcJn
        7AN/DpOE95sD294zBsjjkkWUjUb1w68=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-XDiZuYcKO_WGQUs7g9HE0Q-1; Fri, 16 Jul 2021 03:19:42 -0400
X-MC-Unique: XDiZuYcKO_WGQUs7g9HE0Q-1
Received: by mail-wm1-f69.google.com with SMTP id z127-20020a1c7e850000b02901e46e4d52c0so2078115wmc.6
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 00:19:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LzRNYAtqYOTj/V0dAkfMc1jXJowVL1A+56TG4pOS/EU=;
        b=KREA8oUgSMnItuyfNpm6J0lWldIKIwlirxp2vULue0Vxsa6jHZuRFp3kc7Y599k4Bn
         Wv+Js2A1iP3bas+NB3qUrHqX4Rd7PbtBhN1O/dYeizLWf3IxAfGVYqB6+DBmf41OedZ9
         /gEOHzWju9PnbosVi1F1lsZBsRyCB3dZ7l2WkzHTnysrauPuHu8QxEvJvqxkIOhEVYH0
         2SJTrOz2727w/K2Z8dWeCQJwKlFxHwJAKwB2hnhxEb1b4THGSYMgLehjtjEVqWR10Pxc
         TejxzT3ZwAohWWOc/eFoY38o8SwrTF20sNZYie4Mkhu7XjA3GSF+FkVrvqNgTAQ0tOe7
         0IlQ==
X-Gm-Message-State: AOAM530wNVgQnwpJIEPjC07cdkPccBE4PfPct/VNilkSO6d4x5ZlABki
        AfLX0nigf/gF1bLv2OyXST4hK6/R8nYVqEejefD9ziTCrvbDK0pTcVmJ9qv5GvN+a+srFfgCRW7
        vTAYNrjRDsbTjaTPB
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr8807737wmq.177.1626419981127;
        Fri, 16 Jul 2021 00:19:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBHHyJaVFHknowy3RSublWo7cB7IE9fJELY3Kn03cppdcQEgsTyMLOmb1u0JpBeALFXXjOOQ==
X-Received: by 2002:a05:600c:19d1:: with SMTP id u17mr8807721wmq.177.1626419980944;
        Fri, 16 Jul 2021 00:19:40 -0700 (PDT)
Received: from magray.users.ipa.redhat.com ([109.76.76.230])
        by smtp.gmail.com with ESMTPSA id r67sm10454260wma.6.2021.07.16.00.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 00:19:40 -0700 (PDT)
Reply-To: Mark Gray <mark.d.gray@redhat.com>
Subject: Re: [PATCH net-next v2] openvswitch: Introduce per-cpu upcall
 dispatch
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, dan.carpenter@oracle.com,
        Flavio Leitner <fbl@sysclose.org>
References: <20210715122754.1240288-1-mark.d.gray@redhat.com>
 <CAOrHB_CUyqp-hmamZzkyEea8nOZvGpk57DRQ2EReCKzbtJ4yww@mail.gmail.com>
From:   Mark Gray <mark.d.gray@redhat.com>
Message-ID: <e9a3ae67-a066-b221-bdc1-ab31f18cc6f4@redhat.com>
Date:   Fri, 16 Jul 2021 08:19:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_CUyqp-hmamZzkyEea8nOZvGpk57DRQ2EReCKzbtJ4yww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2021 23:57, Pravin Shelar wrote:
> On Thu, Jul 15, 2021 at 5:28 AM Mark Gray <mark.d.gray@redhat.com> wrote:
>>
>> The Open vSwitch kernel module uses the upcall mechanism to send
>> packets from kernel space to user space when it misses in the kernel
>> space flow table. The upcall sends packets via a Netlink socket.
>> Currently, a Netlink socket is created for every vport. In this way,
>> there is a 1:1 mapping between a vport and a Netlink socket.
>> When a packet is received by a vport, if it needs to be sent to
>> user space, it is sent via the corresponding Netlink socket.
>>
>> This mechanism, with various iterations of the corresponding user
>> space code, has seen some limitations and issues:
>>
>> * On systems with a large number of vports, there is a correspondingly
>> large number of Netlink sockets which can limit scaling.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1526306)
>> * Packet reordering on upcalls.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1844576)
>> * A thundering herd issue.
>> (https://bugzilla.redhat.com/show_bug.cgi?id=1834444)
>>
>> This patch introduces an alternative, feature-negotiated, upcall
>> mode using a per-cpu dispatch rather than a per-vport dispatch.
>>
>> In this mode, the Netlink socket to be used for the upcall is
>> selected based on the CPU of the thread that is executing the upcall.
>> In this way, it resolves the issues above as:
>>
>> a) The number of Netlink sockets scales with the number of CPUs
>> rather than the number of vports.
>> b) Ordering per-flow is maintained as packets are distributed to
>> CPUs based on mechanisms such as RSS and flows are distributed
>> to a single user space thread.
>> c) Packets from a flow can only wake up one user space thread.
>>
>> The corresponding user space code can be found at:
>> https://mail.openvswitch.org/pipermail/ovs-dev/2021-July/385139.html
>>
>> Bugzilla: https://bugzilla.redhat.com/1844576
>> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
>> Acked-by: Flavio Leitner <fbl@sysclose.org>
> 
> Acked-by: Pravin B Shelar <pshelar@ovn.org>
> 
> Thanks,
> 

Thanks for the review Pravin.

