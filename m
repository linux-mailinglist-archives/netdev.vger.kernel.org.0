Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58622682EA5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjAaOBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjAaOBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:01:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE9451439
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675173616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sW7aiMox0CriK8aU+HN+jb3vaXSIy6HBnrk2aPiMthI=;
        b=DXDXUjs1j+oSDtwMH8CON14He89yV5GVsx/QZ09orr2V1wLjeGlaEX2GMGqRdce4vKXgZ1
        zJ+Pw0lY/1t6VfAKyT0g2x5F3uKvRmbhMEWORh6oqFNlRKuiRQ4dOyQ53DJETRb6mAvFfZ
        hyZ6a9yNDQlC6dVPMaZ6a+CyGAgDyCM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-321--Ymk5idQNgWhtAoGUuN35g-1; Tue, 31 Jan 2023 09:00:12 -0500
X-MC-Unique: -Ymk5idQNgWhtAoGUuN35g-1
Received: by mail-wm1-f71.google.com with SMTP id bg32-20020a05600c3ca000b003dc0df8c77dso5914153wmb.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sW7aiMox0CriK8aU+HN+jb3vaXSIy6HBnrk2aPiMthI=;
        b=T0zpCktITOnzrDFU7LjdVB+1PsW7AjkrfSyAtMdUaxTVBcWFKZEnLjS5xqTuWFIJqv
         4wnLG1Vsy7RCBUEJIihkeLPk2RXQ7MfrySLh85mZ5F6lrd2qewpDlMkbnu3NzcZgGgNy
         nGtYqDGay+2VRP+AAzz8II4GDM8ltJsDofwhFcf0PLiUEwDsmMxH/hksqaG+tWL8qCWL
         aDn1liVGIf95ENDDOsyd2Qf44o5AGRoY4KznkxyvYX7C8AOZXyMqhfnsd4/i1E6do8z6
         y9LyEOsQ2wC8kYg0PuRH3HdHd+divJAfGtt5KKiIExIuOJK4f4rDU6Kc3CqMT7j979yy
         Nd2w==
X-Gm-Message-State: AO0yUKW1cU1AuSwF01617vY/HacwDrPAa13ZzqumTxQdQc4fWbLSuNLC
        upiJXebocLDgvC4GrMzBzKOCvy+DCu+M0dE2LvlPANu4hcgc0dZ2iJjD2tFMjCX3xGQ9S/N56Ko
        7MswI9Umwd24j4aG6
X-Received: by 2002:a05:600c:3b84:b0:3dc:1031:14c4 with SMTP id n4-20020a05600c3b8400b003dc103114c4mr3752225wms.14.1675173611364;
        Tue, 31 Jan 2023 06:00:11 -0800 (PST)
X-Google-Smtp-Source: AK7set94yYHCQtMUhLwwFZW2Tw85+OPCk5GgL8jU/FYp0b92bP94albwy2k0jgp6h4ZElMMLuWMq1g==
X-Received: by 2002:a05:600c:3b84:b0:3dc:1031:14c4 with SMTP id n4-20020a05600c3b8400b003dc103114c4mr3752186wms.14.1675173611028;
        Tue, 31 Jan 2023 06:00:11 -0800 (PST)
Received: from ?IPV6:2003:d8:2f0a:ca00:f74f:2017:1617:3ec3? (p200300d82f0aca00f74f201716173ec3.dip0.t-ipconnect.de. [2003:d8:2f0a:ca00:f74f:2017:1617:3ec3])
        by smtp.gmail.com with ESMTPSA id e38-20020a05600c4ba600b003dc434900e1sm11512963wmp.34.2023.01.31.06.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 06:00:10 -0800 (PST)
Message-ID: <658eda9c-d716-fcb7-ba0c-b36f646195f1@redhat.com>
Date:   Tue, 31 Jan 2023 15:00:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC PATCH 01/19] mm: Introduce vm_account
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch, linuxppc-dev@lists.ozlabs.org,
        linux-fpga@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kselftest@vger.kernel.org
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <748338ffe4c42d86669923159fe0426808ecb04d.1674538665.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.01.23 06:42, Alistair Popple wrote:
> Kernel drivers that pin pages should account these pages against
> either user->locked_vm or mm->pinned_vm and fail the pinning if
> RLIMIT_MEMLOCK is exceeded and CAP_IPC_LOCK isn't held.
> 
> Currently drivers open-code this accounting and use various methods to
> update the atomic variables and check against the limits leading to
> various bugs and inconsistencies. To fix this introduce a standard
> interface for charging pinned and locked memory. As this involves
> taking references on kernel objects such as mm_struct or user_struct
> we introduce a new vm_account struct to hold these references. Several
> helper functions are then introduced to grab references and check
> limits.
> 
> As the way these limits are charged and enforced is visible to
> userspace we need to be careful not to break existing applications by
> charging to different counters. As a result the vm_account functions
> support accounting to different counters as required.
> 
> A future change will extend this to also account against a cgroup for
> pinned pages.

The term "vm_account" is misleading, no? VM_ACCOUNT is for accounting 
towards the commit limit ....

-- 
Thanks,

David / dhildenb

