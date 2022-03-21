Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677B44E3104
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352874AbiCUUEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244596AbiCUUEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:04:02 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616FC5BE61
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:02:36 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5608D3F1FC
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647892948;
        bh=MdTz8LIGQFgbUPJdVOKDXzHsgtCOevEhuKpnhVs6eGY=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=klLlNt45wF5v380eoj73K4kvkl/cN7tLtQEYw7OXAnln8FmR9yLI4hiLJ3q0JFIcO
         Sh7XIBjiaXkQQAstK+x8caK04hBdfR07FZpq9fblID0gzRkMBJUdJeoFvYCFuJEiwS
         Eh12T3wEc5jB95tb38rqbhxQId01Ktbp/LHc2R+F56ypFHkDrrcR6+ZvDKfylaAMBq
         YVBnPUOHemSlPGHxjTHcx0Si0bIN+FbfE3J47ghB9zyJ+hUt/viz3J/u39HOEAKuaO
         DYYLWhCtqkNdvxMlOb5uKRv3HxaDbQQMRFXZkW7epZ2wZ2+Q2hcomL+qnbiXL68xyq
         gR5tyAIfyAEDg==
Received: by mail-pl1-f199.google.com with SMTP id ik24-20020a170902ab1800b00153ae512603so6028088plb.14
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=MdTz8LIGQFgbUPJdVOKDXzHsgtCOevEhuKpnhVs6eGY=;
        b=2eaeRqjjfWT9/VxZiv1I/h35PqqAu9EwPjfGvyTp5WzileRTYnfIFPHCBtlTmicyjh
         OSCwcp9Mkxh8fswE7SmqesPCsTeYoGAvGTNPdSXkl/NKvOvcGIRRS1ibmbYNBHbBNaGr
         S3Hmp0xYMiAJhD+fHGafYvzubjTX8ROV2psy/4mSqebjrchFa+NxYyc2V5FrBmuFfeqJ
         9bT7oSTwygPS1D+L1UCwOToE0kcN7rWorcrjzVf7QDWJv9GZ7ORuaIOr8W+drBQKvbOa
         y1VIMZssWr48egpIgZGaZOLMq/ZjfvGWH3y3x40/thQsUZ5PBb629ELOrqaMYv1etjbq
         nL0Q==
X-Gm-Message-State: AOAM5308oAVfE+CcRUmJan/qj6/B+K31pFqbceWyEvUQ3Tg7fmbOri2n
        yGSsGpoVUCPNoY9Ps1+hKDSC2XStku6tkdjqVA1YnKhZPKLC+nBvO3SzMVawvIhgTIK3HLBBsfl
        2lypfamCZ04SrPxBQjyZLu5j9qLG7gcaTYA==
X-Received: by 2002:a17:90a:e7cc:b0:1bf:2500:a493 with SMTP id kb12-20020a17090ae7cc00b001bf2500a493mr842476pjb.37.1647892946895;
        Mon, 21 Mar 2022 13:02:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzh6zxS9NoiXbsyH0RNpoJ9keyqyS3Y4cGzi8+4zvxuQi37Z8vPnIHxiBGk2nCy+v9FJd0dbw==
X-Received: by 2002:a17:90a:e7cc:b0:1bf:2500:a493 with SMTP id kb12-20020a17090ae7cc00b001bf2500a493mr842445pjb.37.1647892946601;
        Mon, 21 Mar 2022 13:02:26 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id i187-20020a62c1c4000000b004faafada2ffsm2160091pfg.204.2022.03.21.13.02.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Mar 2022 13:02:26 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id B2CBE6093D; Mon, 21 Mar 2022 13:02:25 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id AB79CA0B18;
        Mon, 21 Mar 2022 13:02:25 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Alexander Duyck <alexanderduyck@fb.com>
cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Possible to use both dev_mc_sync and __dev_mc_sync?
In-reply-to: <SA1PR15MB51371E4E673D51C1F17E49A6BD169@SA1PR15MB5137.namprd15.prod.outlook.com>
References: <20220321163213.lrn5sk7m6grighbl@skbuf> <SA1PR15MB513713A75488DB88C7222C2DBD169@SA1PR15MB5137.namprd15.prod.outlook.com> <20220321184259.dxohcx6ae2txhqiy@skbuf> <20220321184526.cdpzksga2fu4hyct@skbuf> <SA1PR15MB51371E4E673D51C1F17E49A6BD169@SA1PR15MB5137.namprd15.prod.outlook.com>
Comments: In-reply-to Alexander Duyck <alexanderduyck@fb.com>
   message dated "Mon, 21 Mar 2022 19:13:49 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22190.1647892945.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 21 Mar 2022 13:02:25 -0700
Message-ID: <22191.1647892945@famine>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck <alexanderduyck@fb.com> wrote:

>> -----Original Message-----
>> From: Vladimir Oltean <olteanv@gmail.com>
>> Sent: Monday, March 21, 2022 11:45 AM
>> To: Alexander Duyck <alexanderduyck@fb.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Flo=
rian
>> Fainelli <f.fainelli@gmail.com>; netdev@vger.kernel.org
>> Subject: Re: Possible to use both dev_mc_sync and __dev_mc_sync?
>> =

>> On Mon, Mar 21, 2022 at 08:42:59PM +0200, Vladimir Oltean wrote:
>> > On Mon, Mar 21, 2022 at 06:37:05PM +0000, Alexander Duyck wrote:
>> > > > -----Original Message-----
>> > > > From: Vladimir Oltean <olteanv@gmail.com>
>> > > > Sent: Monday, March 21, 2022 9:32 AM
>> > > > To: Alexander Duyck <alexanderduyck@fb.com>; Jakub Kicinski
>> > > > <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Florian Fainelli
>> > > > <f.fainelli@gmail.com>
>> > > > Cc: netdev@vger.kernel.org
>> > > > Subject: Possible to use both dev_mc_sync and __dev_mc_sync?
>> > > I hadn't intended it to work this way. The expectation was that
>> > > __dev_mc_sync would be used by hardware devices whereas
>> dev_mc_sync
>> > > was used by stacked devices such as vlan or macvlan.
>> >
>> > Understood, thanks for confirming.
>> >
>> > > Probably the easiest way to address it is to split things up so tha=
t
>> > > you are using __dev_mc_sync if the switch supports mc filtering and
>> > > have your dsa_slave_sync/unsync_mc call also push it down to the
>> > > lower device, and then call dev_mc_sync after that so that if it
>> > > hasn't already been pushed to the lower device it gets pushed.
>> >
>> > Yes, I have a patch with that change, just wanted to make sure I'm no=
t
>> > missing something. It's less efficient because now we need to check
>> > whether dsa_switch_supports_uc_filtering() for each address, whereas
>> > before we checked only once, before calling __dev_uc_add(). Oh well.
>> >
>> > > The assumption is that the lower device and the hardware would be
>> > > synced in the same way. If we can't go that route we may have to
>> > > look at implementing a different setup in terms of the reference
>> > > counting such as what is done in __hw_addr_sync_multiple.
>> >
>> > So as mentioned, I haven't really understood the internals of the
>> > reference/sync counting schemes being used here. But why are there
>> > different implementations for dev_mc_sync() and
>> dev_mc_sync_multiple()?
>> =

>> And on the same not of me not quite understanding what goes on, I wonde=
r
>> why some multicast addresses get passed both to the lower dev and to
>> dsa_slave_sync_mc (which is why I didn't notice the problem in the firs=
t
>> place), while others don't.
>
>It all depends on the complexity of the setup. The standard __hw_addr_syn=
c basically assumes you are operating in one of two states.
>Sync: sync_cnt =3D=3D 0, refcount =3D=3D 1 -> sync_cnt =3D 1, refcount++
>Unsync: sync_cnt =3D=3D 1, refcount =3D=3D 1 -> sync_cnt =3D 0, entry del=
eted
>
>I myself am not all that familiar with the multiple approach either,
>however it seems to operate on the idea that the reference count should
>always be greater than the sync count. So the device will hold one
>reference and it will sync the address as long as it doesn't already
>exist in the lower devices address table based on the rules in
>__hw_addr_add_ex.

	Pretty much, yes.  The _sync_multiple versions are for the case
of a device cloning its entire ucast and/or mcast address set to
multiple subordinate devices, e.g., a bond or team to its interfaces.
I've not poked at this in a while, but if memory serves the bond / team
itself is one reference, and then each subordinate device adds a
refcount and a sync_cnt, so the usual case is refcount =3D=3D sync_cnt + 1=
.

	I believe this test in __hw_addr_sync_multiple:

		if (ha->sync_cnt =3D=3D ha->refcount) {
			__hw_addr_unsync_one(to_list, from_list, ha, addr_len);

	is for the "removed a HW address from bond / team, then resync
to subordinate interfaces" case. I.e., the bond / team's refcount has
been released, and the correct action is to remove the "no longer on
bond / team" HW address from the subordinate.

	-J

>Also this might explain why some were synching while others weren't. It
>is possible that the lower dev already had the address present and as
>such was rejected for not being an exclusive address for this device.

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
