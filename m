Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B25607E8F
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 21:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiJUTCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 15:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJUTB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 15:01:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CD1167D6
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666378917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bCAehXcR5h7ebf+5hvfMlvPDY8oPd6LRblF7zIuh6Cs=;
        b=RvVuggWe+KmYZ84t+/bcEFGDCFlatVMQlJ3EgekxIMJsIqOq6O4OuPPJUx8G6Z4itQ7/Mx
        fklG37Fb+j/OoV4SPToBPLG7nXQAi7nFn7wMXFZ7m4R0DP0kNWRHkB7Og8Y+trFA+++srh
        nYNTmpIJEjKm5fUbxOS3jKpyhuBMUmc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-324-hbhI8p9ZOM-xg7Ve2sEQSg-1; Fri, 21 Oct 2022 15:01:54 -0400
X-MC-Unique: hbhI8p9ZOM-xg7Ve2sEQSg-1
Received: by mail-pj1-f72.google.com with SMTP id bx24-20020a17090af49800b0020d9ac4b475so1551045pjb.4
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCAehXcR5h7ebf+5hvfMlvPDY8oPd6LRblF7zIuh6Cs=;
        b=ijm+irkCZW9t9rRUjLc76f0oHxqyGVfHJ8wafLIQBR9hYZR1t6XVdCTfInmh0EgKLe
         iqjtI+P9BBN75QwVNua4+EsqgxmGKXx50oTvAclcDhqNpew3/ZdMkxi3b6y21uC8EQ/V
         7BFkiAMggTLoR/auW45P/lX2Yd+5HXlOmWOSHD15GUEPYH+VQ+6gbbsQJE7t6Jp7JUG5
         3LJFfWoo4E98GHBSetMAxexKSeSl0O6BVbEF+H7lCvSQijE1RiYK4FkKtPddCuMpDp8C
         fnFtqttBe4yXNBuPW/deyp8xV9k1ce4BKD7FzRFsJCUoMUdKYc2AsoJTvkVAxjbal7GL
         HfLw==
X-Gm-Message-State: ACrzQf3GSo/aZlfOkYMTjjOZ1c15HT/MlSUuQbC+qZcljMHWaLPibBgY
        fy/gailycOpGUyvcR3QJbErNMyKdjQw+2fg4qa3cx5K0bWAaQtQeonXkzXWiJp0zjjeS1ALSKtu
        N80AW6ZzWqIAh2g3rOeQnSabE8cMb7bNx
X-Received: by 2002:a63:86c1:0:b0:458:b8d7:71d3 with SMTP id x184-20020a6386c1000000b00458b8d771d3mr16934024pgd.385.1666378913203;
        Fri, 21 Oct 2022 12:01:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7falWNSfFpJetPwvS6Cefk2vdDty1QFvc538gVmkaiJ6LgzUtWTWLXqX3e5fkem7+faECkaf/3JvI9w7eOSSA=
X-Received: by 2002:a63:86c1:0:b0:458:b8d7:71d3 with SMTP id
 x184-20020a6386c1000000b00458b8d771d3mr16933998pgd.385.1666378912861; Fri, 21
 Oct 2022 12:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <20221020075310.15226-1-ihuguet@redhat.com>
 <2945b16a-87b2-9489-cb4f-f578c368f814@marvell.com>
In-Reply-To: <2945b16a-87b2-9489-cb4f-f578c368f814@marvell.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 21 Oct 2022 21:01:41 +0200
Message-ID: <CACT4ouenan4e-vpBZcjpjL-cfrmOWxq7+WOAEnjASzUGVnPEJg@mail.gmail.com>
Subject: Re: [PATCH v2 net] atlantic: fix deadlock at aq_nic_stop
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, mstarovo@pm.me,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:56 AM Igor Russkikh <irusskikh@marvell.com> wrot=
e:
>
>
>
> On 10/20/2022 9:53 AM, =C3=8D=C3=B1igo Huguet wrote:
> > NIC is stopped with rtnl_lock held, and during the stop it cancels the
> > 'service_task' work and free irqs.
>
> Hi =C3=8D=C3=B1igo, thanks for taking care of this.
>
> Just reviewed, overall looks reasonable for me. Unfortunately I don't rec=
all
> now why RTNL lock was used originally, most probably we've tried to secur=
e
> parallel "ip macsec configure something" commands execution.
>
> But the model with internal mutex looks safe for me.
>
> Unfortunately I now have no ability to verify your patch, edge usecase he=
re
> would be to try stress running in parallel:
> "ethtool -S <iface>"
> "ip macsec show"
> "ip macsec <change something>"
> Plus ideal would be link flipping.

I've been running all this in parallel for some hours without issue.


>
> Have you tried something like that?
>
> Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
>
> Regards,
>   Igor
>


--
=C3=8D=C3=B1igo Huguet

