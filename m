Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DDB6C7608
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 03:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCXCzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 22:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXCzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 22:55:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BEEAD33
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 19:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679626494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uAUlOWmnaNVo/VWoXQNmQTS2u7vnkE353p3vcNlNhc=;
        b=DM+GLcVJCLBd0Z+KZlMJRw//lJbnFYGRQRqWIFA8bkiYaysT8nzlHPmDKw8myBrhMkTt0w
        W1JTsEOAsf4AvW9cl4m8jFzSxXgcDep0cK4eQXRMUqnSEN3rl2RgDo3zivL3kgAQC4PgVa
        2MhhNgsBk2wZTCVEc5IauzXlLrmcUfc=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-0ag7ZW4qOQ6QZ_s8tL1ngA-1; Thu, 23 Mar 2023 22:54:51 -0400
X-MC-Unique: 0ag7ZW4qOQ6QZ_s8tL1ngA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1777653e2c4so284624fac.1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 19:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679626491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+uAUlOWmnaNVo/VWoXQNmQTS2u7vnkE353p3vcNlNhc=;
        b=Yu5x86xMmf8HA26rHg9dyE04E5bJWLYzupbzCFsERL1EmW9cQ0Q6/FmhOWdh3r/Uv3
         wtpYo8FitaYGhNfWzFw6u2lmcxUk/biofDzoxMAS7j0KnIGwLKwjA3dnbzSDh3dYUcW4
         wtdl/Z+KXrsXtUu8gJk3tMgE+r3MQQEnzYaI/RwK3PASrn7S1l3ZpTVF5PYxXSQmJOK2
         6825lpKCgw/ODw82I6WI3KygXAAf2SFEv5D0HWtIMnNcOvu7IEkL0HVd2GbsykEBHwOB
         CrTgejy/kSSTWEXPV2+QeIJT0OEG36cspfyMHaUvo80OeXxibRykWpTqWb+7tRB4sYKW
         Wokw==
X-Gm-Message-State: AO0yUKWuL3nitD9/GlSGdkdyAJn1o4PbyQwyNejP+/2jJFc1wcI2nN9q
        A0z1VzZ3d57F44/U5cyKgopCE4FmC4CLb7q2PNd68XWcayDF5EbW2JNHg5Rn19s3DtW8QHlaBA2
        x0J6ZrnBKkH4qXOgrFizb3nMOVFOg4DFG
X-Received: by 2002:a05:6871:b19b:b0:177:9f9c:dc5 with SMTP id an27-20020a056871b19b00b001779f9c0dc5mr512925oac.9.1679626491036;
        Thu, 23 Mar 2023 19:54:51 -0700 (PDT)
X-Google-Smtp-Source: AK7set9fm4WXoQhc8oPxzAxZzgWX14feJUPEMiSJPQgN0rubtFNZsrLMc1kcr+QSYvWg5YQ6SKRhX2omEeiDY+P3wck=
X-Received: by 2002:a05:6871:b19b:b0:177:9f9c:dc5 with SMTP id
 an27-20020a056871b19b00b001779f9c0dc5mr512917oac.9.1679626490818; Thu, 23 Mar
 2023 19:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154804.184577-1-sgarzare@redhat.com> <20230321154804.184577-4-sgarzare@redhat.com>
 <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com> <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
In-Reply-To: <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 24 Mar 2023 10:54:39 +0800
Message-ID: <CACGkMEveMGEzX7bCPuQuqm=9q7Ut-k=MLrRYM3Bq6cMpaw9fVQ@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 5:50=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Thu, Mar 23, 2023 at 11:42:07AM +0800, Jason Wang wrote:
> >On Tue, Mar 21, 2023 at 11:48=E2=80=AFPM Stefano Garzarella <sgarzare@re=
dhat.com> wrote:
> >>
> >> The new "use_va" module parameter (default: true) is used in
> >> vdpa_alloc_device() to inform the vDPA framework that the device
> >> supports VA.
> >>
> >> vringh is initialized to use VA only when "use_va" is true and the
> >> user's mm has been bound. So, only when the bus supports user VA
> >> (e.g. vhost-vdpa).
> >>
> >> vdpasim_mm_work_fn work is used to serialize the binding to a new
> >> address space when the .bind_mm callback is invoked, and unbinding
> >> when the .unbind_mm callback is invoked.
> >>
> >> Call mmget_not_zero()/kthread_use_mm() inside the worker function
> >> to pin the address space only as long as needed, following the
> >> documentation of mmget() in include/linux/sched/mm.h:
> >>
> >>   * Never use this function to pin this address space for an
> >>   * unbounded/indefinite amount of time.
> >
> >I wonder if everything would be simplified if we just allow the parent
> >to advertise whether or not it requires the address space.
> >
> >Then when vhost-vDPA probes the device it can simply advertise
> >use_work as true so vhost core can use get_task_mm() in this case?
>
> IIUC set user_worker to true, it also creates the kthread in the vhost
> core (but we can add another variable to avoid this).
>
> My biggest concern is the comment in include/linux/sched/mm.h.
> get_task_mm() uses mmget(), but in the documentation they advise against
> pinning the address space indefinitely, so I preferred in keeping
> mmgrab() in the vhost core, then call mmget_not_zero() in the worker
> only when it is running.

Ok.

>
> In the future maybe mm will be used differently from parent if somehow
> it is supported by iommu, so I would leave it to the parent to handle
> this.

This should be possible, I was told by Intel that their IOMMU can
access the process page table for shared virtual memory.

Thanks

>
> Thanks,
> Stefano
>

