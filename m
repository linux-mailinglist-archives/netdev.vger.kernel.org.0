Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 015D262E6DC
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbiKQVTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbiKQVSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:18:44 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2788D4BC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:16:46 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id a27so1964545qtw.10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8qHr/A/HsR6Kfxxon9N/W//z78EQTrNeI3dtZDxgu7I=;
        b=x6vjBoSKE06VUDrF0LUklQxJ155Vc79k910vj+TloiikwANfBEGLQyuSx+GirdDBdH
         uRgZ6uJnzL/KCLdVW6cquOTXbLWm+qak55ZkpCZpwn2nen2rCmmA04UdZWV15jumMuoF
         MEr+FMLvbF+9/HBDcpgr2nxLtnd/RyJoIOs/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qHr/A/HsR6Kfxxon9N/W//z78EQTrNeI3dtZDxgu7I=;
        b=1YBEAaKPyHdOujZalJLvDqgHlhTgmaAWWa7r/At49ciFHu+DmLxKR3eiDXnjcul5zb
         VR5IBe+hiAD+pkW66TG3aBvN/Dz42t5NyvAU3lF+YlNkPq6oVV68Tc6LAcRqGsfC0fwB
         a4SqZqi61mRk/4tQtPe3xgjD+FGltI9npGSB7GourYuorRrvezAjYzfc8wk5pKBgTJPv
         NAGokYtbqTr/RNijdF1mb7cjWg2gw8SxCDCm4vfdb1q0V0S8ahgpkhNFzIUUjbZ4lCCP
         UXvQrE+A9zvEiGMmN6RI4fNergb2dgJEov2FXYIofW0j9DswRu4Lt2nQp/wvKGdtRVEp
         blPw==
X-Gm-Message-State: ANoB5plMWJo7CVB7b63aReMlTfjOcC5rQ8gdXcNpu/ZBKRk7HwFBD9ui
        tqUt22V1TX1mP5pE6hjUmvDYCg==
X-Google-Smtp-Source: AA0mqf6khvBt7GMR8wp7GqQGnscxyK0aMMVFMnZPQGmleS/expSz6dqWfBEJ0QH2An3wc4fpRwsjSQ==
X-Received: by 2002:a05:622a:514d:b0:3a5:258c:d69c with SMTP id ew13-20020a05622a514d00b003a5258cd69cmr4065956qtb.279.1668719805959;
        Thu, 17 Nov 2022 13:16:45 -0800 (PST)
Received: from smtpclient.apple (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id az20-20020a05620a171400b006ec771d8f89sm1162744qkb.112.2022.11.17.13.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 13:16:44 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH rcu/dev 3/3] net: Use call_rcu_flush() for dst_destroy_rcu
Date:   Thu, 17 Nov 2022 16:16:43 -0500
Message-Id: <CC3744B1-20A7-4628-873A-2551938009D4@joelfernandes.org>
References: <20221117192949.GD4001@paulmck-ThinkPad-P17-Gen-1>
Cc:     Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, jiejiang@google.com,
        Thomas Glexiner <tglx@linutronix.de>
In-Reply-To: <20221117192949.GD4001@paulmck-ThinkPad-P17-Gen-1>
To:     paulmck@kernel.org
X-Mailer: iPhone Mail (19G82)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 17, 2022, at 2:29 PM, Paul E. McKenney <paulmck@kernel.org> wrote:
>=20
> =EF=BB=BFOn Thu, Nov 17, 2022 at 05:40:40PM +0000, Joel Fernandes wrote:
>>> On Thu, Nov 17, 2022 at 5:38 PM Joel Fernandes <joel@joelfernandes.org> w=
rote:
>>>=20
>>> On Thu, Nov 17, 2022 at 5:17 PM Eric Dumazet <edumazet@google.com> wrote=
:
>>>>=20
>>>> On Thu, Nov 17, 2022 at 7:58 AM Joel Fernandes <joel@joelfernandes.org>=
 wrote:
>>>>>=20
>>>>> Hello Eric,
>>>>>=20
>>>>> On Wed, Nov 16, 2022 at 07:44:41PM -0800, Eric Dumazet wrote:
>>>>>> On Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
>>>>>> <joel@joelfernandes.org> wrote:
>>>>>>>=20
>>>>>>> In a networking test on ChromeOS, we find that using the new CONFIG_=
RCU_LAZY
>>>>>>> causes a networking test to fail in the teardown phase.
>>>>>>>=20
>>>>>>> The failure happens during: ip netns del <name>
>>>>>>=20
>>>>>> And ? What happens then next ?
>>>>>=20
>>>>> The test is doing the 'ip netns del <name>' and then polling for the
>>>>> disappearance of a network interface name for upto 5 seconds. I believ=
e it is
>>>>> using netlink to get a table of interfaces. That polling is timing out=
.
>>>>>=20
>>>>> Here is some more details from the test's owner (copy pasting from ano=
ther
>>>>> bug report):
>>>>> In the cleanup, we remove the netns, and thus will cause the veth pair=
 being
>>>>> removed automatically, so we use a poll to check that if the veth in t=
he root
>>>>> netns still exists to know whether the cleanup is done.
>>>>>=20
>>>>> Here is a public link to the code that is failing (its in golang):
>>>>> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:sr=
c/platform/tast-tests/src/chromiumos/tast/local/network/virtualnet/env/env.g=
o;drc=3D6c2841d6cc3eadd23e07912ec331943ee33d7de8;l=3D161
>>>>>=20
>>>>> Here is a public link to the line of code in the actual test leading u=
p to the above
>>>>> path (this is the test that is run:
>>>>> network.RoutingFallthrough.ipv4_only_primary) :
>>>>> https://source.chromium.org/chromiumos/chromiumos/codesearch/+/main:sr=
c/platform/tast-tests/src/chromiumos/tast/local/bundles/cros/network/routing=
_fallthrough.go;drc=3D8fbf2c53960bc8917a6a01fda5405cad7c17201e;l=3D52
>>>>>=20
>>>>>>> Using ftrace, I found the callbacks it was queuing which this series=
 fixes. Use
>>>>>>> call_rcu_flush() to revert to the old behavior. With that, the test p=
asses.
>>>>>>=20
>>>>>> What is this test about ? What barrier was used to make it not flaky ?=

>>>>>=20
>>>>> I provided the links above, let me know if you have any questions.
>>>>>=20
>>>>>> Was it depending on some undocumented RCU behavior ?
>>>>>=20
>>>>> This is a new RCU feature posted here for significant power-savings on=

>>>>> battery-powered devices:
>>>>> https://lore.kernel.org/rcu/20221017140726.GG5600@paulmck-ThinkPad-P17=
-Gen-1/T/#m7a54809b8903b41538850194d67eb34f203c752a
>>>>>=20
>>>>> There is also an LPC presentation about the same, I can dig the link i=
f you
>>>>> are interested.
>>>>>=20
>>>>>> Maybe adding a sysctl to force the flush would be better for function=
al tests ?
>>>>>>=20
>>>>>> I would rather change the test(s), than adding call_rcu_flush(),
>>>>>> adding merge conflicts to future backports.
>>>>>=20
>>>>> I am not too sure about that, I think a user might expect the network
>>>>> interface to disappear from the networking tables quickly enough witho=
ut
>>>>> dealing with barriers or kernel iternals. However, I added the authors=
 of the
>>>>> test to this email in the hopes he can provide is point of views as we=
ll.
>>>>>=20
>>>>> The general approach we are taking with this sort of thing is to use
>>>>> call_rcu_flush() which is basically the same as call_rcu() for systems=
 with
>>>>> CALL_RCU_LAZY=3Dn. You can see some examples of that in the patch seri=
es link
>>>>> above. Just to note, CALL_RCU_LAZY depends on CONFIG_RCU_NOCB_CPU so i=
ts only
>>>>> Android and ChromeOS that are using it. I am adding Jie to share any i=
nput,
>>>>> he is from the networking team and knows this test well.
>>>>>=20
>>>>>=20
>>>>=20
>>>> I do not know what is this RCU_LAZY thing, but IMO this should be opt-i=
n
>>>=20
>>> You should read the links I sent you. We did already try opt-in,
>>> Thomas Gleixner made a point at LPC that we should not add new APIs
>>> for this purpose and confuse kernel developers.
>>>=20
>>>> For instance, only kfree_rcu() should use it.
>>>=20
>>> No. Most of the call_rcu() usages are for freeing memory, so the
>>> consensus is we should apply this as opt out and fix issues along the
>>> way. We already did a lot of research/diligence on seeing which users
>>> need conversion.
>>>=20
>>>> We can not review hundreds of call_rcu() call sites and decide if
>>>> adding arbitrary delays cou hurt .
>>>=20
>>> That work has already been done as much as possible, please read the
>>> links I sent.
>>=20
>> Also just to add, this test is a bit weird / corner case, as in anyone
>> expecting a quick response from call_rcu() is broken by design.
>> However, for these callbacks, it does not matter much which API they
>> use as they are quite infrequent for power savings.
>=20
> The "broken by design" is a bit strong.  Some of those call_rcu()
> invocations have been around for the better part of 20 years, after all.
>=20
> That aside, I do hope that we can arrive at something that will enhance
> battery lifetime while avoiding unnecessary disruption.  But we are
> unlikely to be able to completely avoid disruption.  As this email
> thread illustrates.  ;-)

Another approach, with these 3 patches could be to keep the call_rcu() but a=
dd an rcu_barrier() after them. I think people running ip del netns should n=
ot have to wait for their RCU cb to take too long to run and remove user vis=
ible state. But I would need suggestions from networking experts which CBs o=
f these 3, to do this for. Or for all of them.

Alternatively, we can also patch just the test with a new knob that does rcu=
_barrier. But I dislike that as it does not fix it for all users. Probably t=
he ip utilities will also need a patch then.

Thanks,

- Joel=20


>=20
>                            Thanx, Paul
