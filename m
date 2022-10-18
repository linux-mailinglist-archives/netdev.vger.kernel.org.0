Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3347060242B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJRGL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiJRGL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:11:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E774D15D
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666073484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hQBNQz/U8mFO09zvEN+UfVGtB1JLY//+CF8Lq0saZEc=;
        b=Ov8smCL1NYL5Vn+qB4n10UL27/5E2N2lAt9B5AWxSZ0CAuN4BZISuxoBg9mdgSqP4Y9Gn0
        fLf3XoVoL5sSA6q/x1tQWn+mWHV/1St25ZoKx/B9JY0gzEZV/Bhum3Ss+sfcGLcaNXXWQn
        9q5nCBgGIGGSXVQsx5EWYC9Sg/eyyzw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-190-NYetqroxPZaMjz71OzkYNQ-1; Tue, 18 Oct 2022 02:11:23 -0400
X-MC-Unique: NYetqroxPZaMjz71OzkYNQ-1
Received: by mail-pg1-f199.google.com with SMTP id k64-20020a638443000000b004620970e0dbso7540481pgd.6
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hQBNQz/U8mFO09zvEN+UfVGtB1JLY//+CF8Lq0saZEc=;
        b=16dq11GH5m4RKf/fPg6RLhF3Yka02b2uGud9RAyARm/UMcWO+FSPQyf3HizLgLO3l6
         9wIPgQs9XlMx/uLz5izbNVxyinsapDe87MZ4efc4LhYNxINArG5mQT6xOCEnPRw/G4VF
         kdStwk0zwGrM2WKIRnoRfQMPWO0+u000rp1vl8yUxQ+efxAVixThR8b38enPUUGSFN4Y
         TiCDYlhNtAfyPjOEtADkhTGm95jnOljJF3fTW2pR/wdg5MltBFUftBhU2fcpvEAyFOVl
         GPJi4sr5kaiN4NtEYjmVq3LBPLZ6NmFU+jaOQUQ0254EUNu1yBVjEwjqHBYEvCMyYHrB
         DsTg==
X-Gm-Message-State: ACrzQf14uFwoQ5lbCKQnofWb/TQrDSv8xMnON7Icxb2L1gt9Q97QZ8Wj
        iGAfw8pG7ceACEHCdBOf6oacefWPAFkh49O0e9Fa5jWe6Pbh2ehsOsQ4jKEbsD7ReCEwvKqHaPe
        L8AE+mbo8zEVW9HnyynPSxWiosOBjeJkN
X-Received: by 2002:a17:903:18c:b0:185:5211:c6e8 with SMTP id z12-20020a170903018c00b001855211c6e8mr1503812plg.133.1666073482410;
        Mon, 17 Oct 2022 23:11:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7m+Bis6wjzMZ4fYzfkrKVoio5U6aSuXaeUPLLiC5GtJHLu7Z0Lnyy1d/N1R9WnNxJtADC/c7EmnKxYrpayrlE=
X-Received: by 2002:a17:903:18c:b0:185:5211:c6e8 with SMTP id
 z12-20020a170903018c00b001855211c6e8mr1503790plg.133.1666073482136; Mon, 17
 Oct 2022 23:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch> <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
 <Y0rNLpmCjHVoO+D1@lunn.ch> <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
 <Y03y/D8WszbjmSwZ@lunn.ch>
In-Reply-To: <Y03y/D8WszbjmSwZ@lunn.ch>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 18 Oct 2022 08:11:10 +0200
Message-ID: <CACT4oudiN82eWw+cpB8K12TKGdNjyB74OcYEq9kn13GpT+=ndg@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 2:28 AM Andrew Lunn <andrew@lunn.ch> wrote:
> Did you look at other drivers using MACSEC offload? Is this driver
> unique in having stuff run in a work queue which you need to cancel?
> In fact, it is not limited to MACSEC, it could be any work queue which
> holds RTNL and needs to be cancelled.

Yes, I did.

About other drivers using MACSEC offload (which are only 2): they
don't have work or anything similar related to macsec where they need
to take rtnl_lock or any other lock. But in this driver the need of a
lock seems justified, at least as far as I can understand.

About other drivers having works that need to take rtnl_lock: they
cancel it in PCI shutdown/remove functions, then call
unregister_netdev, acquiring rtnl_lock. I considered doing the same,
but I didn't for 2 reasons:
1. There is no need to have a periodic task running for a stopped NIC
2. The task uses some resources that are deinitialized at NIC stop and
try to communicate with NIC's firmware. If it's stopped in a way
different to PCI shutdown/remove (i.e. ip link set down) the task
would continue to be executed and try to use these deinitialized
resources and communicate with a stopped hw.

Of course that point 2 possibly can be fixed to avoid doing it if NIC
has been stopped, but it still remains point 1. I didn't research if
other drivers really need to have the task running periodically even
with the NIC stopped, but I certainly know that this one doesn't need
it, looking at what the task does.

I do appreciate feedback, suggestions and changes requests (actually I
happily accepted to send v2 according to them, right?). But I'd rather
if they contained more specific proposals and examples of what I can
do to improve my patches, instead of just suggesting that I should do
some research before sending them, because I already did.

Best regards
--=20
=C3=8D=C3=B1igo Huguet

