Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31F8698F0D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjBPIwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBPIwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:52:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00003A0A1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676537503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cw5EXbqS5GBdkBdHdksHNKXOrceq2Yrj2dKjz3qw/YY=;
        b=PpNHtwCekcoEcs/wfVbX6uTkIfXANf8CFTUqTiz6K1W6UF/53SyZ4eDl930jceKeld2jz/
        J9ri6fZX+Z6qMiQOIsQrzVBHiDu6p1JrjlrscJinNwfIAWh/sJJ6HS0X6trcHN6/+dvGm7
        Ne+2jcGUbW+78Bjfs4qeUP/cKO10Mjs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-552-qt3mciJWO3araCXC-6VEoA-1; Thu, 16 Feb 2023 03:51:42 -0500
X-MC-Unique: qt3mciJWO3araCXC-6VEoA-1
Received: by mail-qt1-f199.google.com with SMTP id g26-20020ac8481a000000b003bd01832685so867178qtq.3
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676537502;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cw5EXbqS5GBdkBdHdksHNKXOrceq2Yrj2dKjz3qw/YY=;
        b=N7guj7g4dC+ecyNMG7i/MYOXJqxnoi2xrjiir0MPv0fnRxWd+Qde8xkHFDqhGoAcCo
         yq5KuwCQDMpdNZWJ9nrfX9nDbdU8yRX+fc2m7b62k8DK1ZE1xuDntfzvGDju/ezXjhzD
         J1j9aGtm4etYDhp3I6DCvTmRsdWDGerh4XvAbIpVH9NzbuDGXBSbPjRP/2XXTbV+VGEu
         +hFP4A3c/rizpOfJrW1/el2A/5TfORFC2/+Wwp+nf5NlYD7vTf7Aja92ARBF06+pywE7
         s0cDmGsaFpbmILb8Y4vl7eIi1AB5mCEmaoUCxU26N3gh2HHqeSwQqaaV3vm0AjBTtDS7
         zxcw==
X-Gm-Message-State: AO0yUKV+yBKKv0yu7Fra3x6I3izzJb0uCbfoUpSGG0E1KTnUFHgN/gU4
        ndtwIY+7zLtVIv5uMw+ITQEeowhbNuAJM6PvpND+uPDWKkZ4GLWPyJUs9klq9r1YbWucfqWNvbV
        sUMGw8a2kJgGvPdDsprX4cQ==
X-Received: by 2002:ac8:5b0f:0:b0:3b8:68df:fc72 with SMTP id m15-20020ac85b0f000000b003b868dffc72mr9686195qtw.2.1676537501749;
        Thu, 16 Feb 2023 00:51:41 -0800 (PST)
X-Google-Smtp-Source: AK7set8UBLnbEPtK7CRdOuAWxbwHFLMTPF8ZcFbkP7D+dGeyzG5Bvyfw1duTKfOa4HmprkyCSYakXw==
X-Received: by 2002:ac8:5b0f:0:b0:3b8:68df:fc72 with SMTP id m15-20020ac85b0f000000b003b868dffc72mr9686175qtw.2.1676537501402;
        Thu, 16 Feb 2023 00:51:41 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id v1-20020a372f01000000b00721299cfffesm791787qkh.39.2023.02.16.00.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 00:51:40 -0800 (PST)
Message-ID: <2d60510f63dcd462a74ee5c4d4d26a2ceb405d21.camel@redhat.com>
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Date:   Thu, 16 Feb 2023 09:51:37 +0100
In-Reply-To: <20230214134915.199004-1-jhs@mojatatu.com>
References: <20230214134915.199004-1-jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-14 at 08:49 -0500, Jamal Hadi Salim wrote:
> The CBQ + dsmark qdiscs and the tcindex + rsvp classifiers have served us=
 for
> over 2 decades. Unfortunately, they have not been getting much attention =
due
> to reduced usage. While we dont have a good metric for tabulating how muc=
h use
> a specific kernel feature gets, for these specific features we observed t=
hat
> some of the functionality has been broken for some time and no users comp=
lained.
> In addition, syzkaller has been going to town on most of these and findin=
g
> issues; and while we have been fixing those issues, at times it becomes o=
bvious
> that we would need to perform bigger surgeries to resolve things found wh=
ile
> getting a syzkaller fix in place. After some discussion we feel that in o=
rder
> to reduce the maintenance burden it is best to retire them.
>=20
> This patchset leaves the UAPI alone. I could send another version which d=
eletes
> the UAPI as well. AFAIK, this has not been done before - so it wasnt clea=
r what
> how to handle UAPI. It seems legit to just delete it but we would need to
> coordinate with iproute2 (given they sync up with kernel uapi headers). T=
here
> are probably other users we don't know of that copy kernel headers.
> If folks feel differently I will resend the patches deleting UAPI for the=
se
> qdiscs and classifiers.

I guess we could additionally remove all the references to the retired
qdiscs and classifiers from the default configs and from the self-tests
dependencies.

AFAICS such references do not cause any problem, as the now unexisting
kconfig knobs are automatically stripped at config generation time by
kbuild, but possibly worth a follow-up patch/series.

Thanks!

Paolo


