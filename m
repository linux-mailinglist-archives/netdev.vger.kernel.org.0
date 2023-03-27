Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC16C99F2
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjC0DNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjC0DNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:13:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2554949C6
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 20:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679886767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I7jMSq1Oqt89DeEKZ9wwG6GQzFOitJhSi8FbGeviIdQ=;
        b=X0D0VflUZgQOpDxzlXFn4QIc1o5YnE+tOhqmSMPS6dLMm4t295i2TOL20IeP54Yh+bObe3
        8Tze6Oo3lBUGD2a1xVI5BHxCQh89sI7kpJNjYq+/l1+Xqrx1UrKgtQkienmtERKeoDpCqA
        Ry74K9hvA38nv1+QliW5uCpiBwI0A6k=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-JK-g-D5POGmqFFf7kkbwcg-1; Sun, 26 Mar 2023 23:12:45 -0400
X-MC-Unique: JK-g-D5POGmqFFf7kkbwcg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-17a678c2de9so4537473fac.14
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 20:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679886765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I7jMSq1Oqt89DeEKZ9wwG6GQzFOitJhSi8FbGeviIdQ=;
        b=GvCicbouO/BHkHCAmm0xS1n4owaPejmv8PYMmrvTkBO2jJZJuGPxFwsVGec3ty+YSb
         dhGnyV14XklcO+qeZCGb/oiOiY5i+sQtozzap0WnjO6PM8aEMMR82gvO7Y+jdoJEjI95
         +ZbpqSBJl48ETP3qOA1Av+NA4TSnIXy0NGLKvZtJyIgstAvAbR8xjtcEuCaxiqgmUSYg
         wCI4q5ugQP2WgMI2/2qJCoKbwCUpKpVZ7Hmyba8lDHhBb155sQFOUw5IGGODcvRY67z1
         ZP2P+hM6G6OptC1VMiE2lD4W0UFMvb/ZvseFSbUWMhtHIwZpK94c/LLTXSpzVvkCvnAp
         Vlkg==
X-Gm-Message-State: AAQBX9cVWjMi0ivYF1tPYyPY8yXy+QFE6sbnxDUmuG3Zn7dS6/gNpxHd
        f76lqO7KVW8clqyIqE/98X0n4naIp87uDtkNk0+lgFkWUkLG2J/C2+rmqX/VKkIT2MqswXj9HXc
        PxibdeP5WxcVtESHFw0+OvEM5tc9MJVPA
X-Received: by 2002:a05:6870:8f4a:b0:177:83f7:351c with SMTP id vc10-20020a0568708f4a00b0017783f7351cmr2311951oab.9.1679886764947;
        Sun, 26 Mar 2023 20:12:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set/emaj9r+Vxf+kzhwxYeXBBP9ZYc2AJ2G4IeDWGc0VKHvSlfscQfpo+8V4vu4wuKne4BrxS4VXeDZqMOFGn7Ds=
X-Received: by 2002:a05:6870:8f4a:b0:177:83f7:351c with SMTP id
 vc10-20020a0568708f4a00b0017783f7351cmr2311941oab.9.1679886764731; Sun, 26
 Mar 2023 20:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230321154804.184577-1-sgarzare@redhat.com> <20230321154804.184577-4-sgarzare@redhat.com>
 <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
 <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat> <CACGkMEveMGEzX7bCPuQuqm=9q7Ut-k=MLrRYM3Bq6cMpaw9fVQ@mail.gmail.com>
 <j6d2b5zqbb7rlrem76wopsabyy344wwnkbutvacebcig5fupnu@a2xkhywajwta>
In-Reply-To: <j6d2b5zqbb7rlrem76wopsabyy344wwnkbutvacebcig5fupnu@a2xkhywajwta>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 27 Mar 2023 11:12:33 +0800
Message-ID: <CACGkMEugnjm4U1h9JTzMh0yJ1MnsgJR=pYEO96YsTNEYLoiR-g@mail.gmail.com>
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

On Fri, Mar 24, 2023 at 10:43=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> On Fri, Mar 24, 2023 at 10:54:39AM +0800, Jason Wang wrote:
> >On Thu, Mar 23, 2023 at 5:50=E2=80=AFPM Stefano Garzarella <sgarzare@red=
hat.com> wrote:
> >>
> >> On Thu, Mar 23, 2023 at 11:42:07AM +0800, Jason Wang wrote:
> >> >On Tue, Mar 21, 2023 at 11:48=E2=80=AFPM Stefano Garzarella <sgarzare=
@redhat.com> wrote:
> >> >>
> >> >> The new "use_va" module parameter (default: true) is used in
> >> >> vdpa_alloc_device() to inform the vDPA framework that the device
> >> >> supports VA.
> >> >>
> >> >> vringh is initialized to use VA only when "use_va" is true and the
> >> >> user's mm has been bound. So, only when the bus supports user VA
> >> >> (e.g. vhost-vdpa).
> >> >>
> >> >> vdpasim_mm_work_fn work is used to serialize the binding to a new
> >> >> address space when the .bind_mm callback is invoked, and unbinding
> >> >> when the .unbind_mm callback is invoked.
> >> >>
> >> >> Call mmget_not_zero()/kthread_use_mm() inside the worker function
> >> >> to pin the address space only as long as needed, following the
> >> >> documentation of mmget() in include/linux/sched/mm.h:
> >> >>
> >> >>   * Never use this function to pin this address space for an
> >> >>   * unbounded/indefinite amount of time.
> >> >
> >> >I wonder if everything would be simplified if we just allow the paren=
t
> >> >to advertise whether or not it requires the address space.
> >> >
> >> >Then when vhost-vDPA probes the device it can simply advertise
> >> >use_work as true so vhost core can use get_task_mm() in this case?
> >>
> >> IIUC set user_worker to true, it also creates the kthread in the vhost
> >> core (but we can add another variable to avoid this).
> >>
> >> My biggest concern is the comment in include/linux/sched/mm.h.
> >> get_task_mm() uses mmget(), but in the documentation they advise again=
st
> >> pinning the address space indefinitely, so I preferred in keeping
> >> mmgrab() in the vhost core, then call mmget_not_zero() in the worker
> >> only when it is running.
> >
> >Ok.
> >
> >>
> >> In the future maybe mm will be used differently from parent if somehow
> >> it is supported by iommu, so I would leave it to the parent to handle
> >> this.
> >
> >This should be possible, I was told by Intel that their IOMMU can
> >access the process page table for shared virtual memory.
>
> Cool, we should investigate this. Do you have any pointers to their
> documentation?

The vtd-spec I think.

Thanks

>
> Thanks,
> Stefano
>

