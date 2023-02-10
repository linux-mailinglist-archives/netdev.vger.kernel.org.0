Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5BB69219E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbjBJPH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjBJPH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:07:57 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADB2FF28
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:07:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bk16so5344094wrb.11
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qlNC/kKbUsPlOCKxymEIios8n2ASOqnWF3/GBA5cjF8=;
        b=lUiODl6bVd/fiZW4XlYgkYvOyJLav2vvyyiWeUXwQEPV09CChytAMwjjvRT0y6b2gx
         3tGbsprUTD5PgTf821cAG8WnuE71fRwT7VI07pUdubcRoTjoscHc6fOnt8jUeo6blWaf
         3C3aY8Wxj5ut8lRP6XRG918amBW2lPMn2hZgDTcJ/Fu8u01vC8CoMWe5LsO5qvG4XOku
         p0X1zCcFem9m7EENqaeQQUm9aRx7DMErky8UyerVpVYP5JFH9npBkyA/AYrPGwelLvAh
         2tYbYNRlWECWCWVqp6BvTzPlJYqx6gFOva9Yr6HDm7sdM+Xz5myPKiWX5kRb74BBwCbm
         vMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qlNC/kKbUsPlOCKxymEIios8n2ASOqnWF3/GBA5cjF8=;
        b=RshkidAOayUOq3CxQq1h2vnjZsigZlcLDVmMGd6DYhOrQDhDZ4lyBCBBap4hZT5p75
         A6R2bCBZksi4y6BVr53DuCEEECsvGFpahw4OUJPTvUHL6ppGU/Y0w/RxS3FhWiRKxZWy
         2Uc4TRSuQkXPBS8jNlSmmXhMxP7vMhZHPj0h2L9COIlUzcwPSXgtKE1ds7H1q3qF1//K
         Bs5RTUp0aVyzH/WI69jHBoUDi7ZORDm6Ap8CzfPXylfuaxTOFqAnWNCRJUZ81SwamBvY
         Snw6v6m3hf0RcDfZwHSfPlZyyuVfWC9R3TxP6o7AHog+VeJdStqyfOC+1T4SUhBVN7dQ
         bl1Q==
X-Gm-Message-State: AO0yUKVhWoTziX08q1QvDorr/CLfGi2f48q92a91aeuBSoytfQ7bohVh
        nQXa55VhB45P+Mp2E09qh3i7bobszU1Ui96AYz0vxvWPLldp573OkqQ=
X-Google-Smtp-Source: AK7set9TQ9KQwoqhGEVIEcXvcv/U/mBHAlTVV6SnxMr8fK8HsjlFlHF/wol0CSMUXWf24slV/I76/nqHc2iMbAXrygg=
X-Received: by 2002:a5d:6583:0:b0:2c4:936:f423 with SMTP id
 q3-20020a5d6583000000b002c40936f423mr475464wru.113.1676041673935; Fri, 10 Feb
 2023 07:07:53 -0800 (PST)
MIME-Version: 1.0
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com> <20230207135440.1482856-11-vladimir.oltean@nxp.com>
In-Reply-To: <20230207135440.1482856-11-vladimir.oltean@nxp.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Feb 2023 16:07:42 +0100
Message-ID: <CANn89iL=Z8TOymdaBJ8WUBh8pXOgp_tKM3KVsQZ05uT3orOj4w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 10/15] net/sched: make stab available before
 ops->init() call
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 7, 2023 at 2:55 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> Some qdiscs like taprio turn out to be actually pretty reliant on a well
> configured stab, to not underestimate the skb transmission time (by
> properly accounting for L1 overhead).
>
> In a future change, taprio will need the stab, if configured by the
> user, to be available at ops->init() time. It will become even more
> important in upcoming work, when the overhead will be used for the
> queueMaxSDU calculation that is passed to an offloading driver.
>
> However, rcu_assign_pointer(sch->stab, stab) is called right after
> ops->init(), making it unavailable, and I don't really see a good reason
> for that.
>
> Move it earlier, which nicely seems to simplify the error handling path
> as well.

Well... if you say so :)

>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
>

If TCA_STAB attribute is malformed, we end up calling ->destroy() on a
not yet initialized qdisc :/

I am going to send the following fix, unless someone disagrees.

(Moving qdisc_put_stab() _after_ ops->destroy(sch) is not strictly
needed for a fix,
but undo should be done in reverse steps for clarity.

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index e9780631b5b58202068e20c42ccf1197eac2194c..aba789c30a2eb50d339b8a888495b794825e1775
100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1286,7 +1286,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
                stab = qdisc_get_stab(tca[TCA_STAB], extack);
                if (IS_ERR(stab)) {
                        err = PTR_ERR(stab);
-                       goto err_out4;
+                       goto err_out3;
                }
                rcu_assign_pointer(sch->stab, stab);
        }
@@ -1294,14 +1294,14 @@ static struct Qdisc *qdisc_create(struct
net_device *dev,
        if (ops->init) {
                err = ops->init(sch, tca[TCA_OPTIONS], extack);
                if (err != 0)
-                       goto err_out5;
+                       goto err_out4;
        }

        if (tca[TCA_RATE]) {
                err = -EOPNOTSUPP;
                if (sch->flags & TCQ_F_MQROOT) {
                        NL_SET_ERR_MSG(extack, "Cannot attach rate
estimator to a multi-queue root qdisc");
-                       goto err_out5;
+                       goto err_out4;
                }

                err = gen_new_estimator(&sch->bstats,
@@ -1312,7 +1312,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
                                        tca[TCA_RATE]);
                if (err) {
                        NL_SET_ERR_MSG(extack, "Failed to generate new
estimator");
-                       goto err_out5;
+                       goto err_out4;
                }
        }

@@ -1321,12 +1321,13 @@ static struct Qdisc *qdisc_create(struct
net_device *dev,

        return sch;

-err_out5:
-       qdisc_put_stab(rtnl_dereference(sch->stab));
 err_out4:
-       /* ops->init() failed, we call ->destroy() like qdisc_create_dflt() */
+       /* Even if ops->init() failed, we call ops->destroy()
+        * like qdisc_create_dflt().
+        */
        if (ops->destroy)
                ops->destroy(sch);
+       qdisc_put_stab(rtnl_dereference(sch->stab));
 err_out3:
        netdev_put(dev, &sch->dev_tracker);
        qdisc_free(sch);
