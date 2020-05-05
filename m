Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658FC1C59BA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgEEOfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729282AbgEEOfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:35:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5D2C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:35:54 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q8so1855435eja.2
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3CTbQj7+T5lQ2eAoPyur9Oo1co6LLPaOcAEjbkl5sM=;
        b=ApZZlOlV1lKNX9z4hmjYqVay6xIO6Yex1ltjEU9eUGf3Vo8rDELxUxD7yfnXk55v7m
         TqscFA1V3Y7ezYy+4f7l9OqMMPn1PcFCxFqVytKRpEyJp8J+xVwxMeWAUhbF42SCaqMJ
         8rqnTvtM3ClzyU8zD5BW9aHw2D5h2FG+VWn0xDMXCLVANj7MnP7l6DT/qKfQORatZFSQ
         4K1G/VZoLVRW9Jj60HdEpO8DUcwEqGtAvXH4sOO8VSGkey/vnY7CsuHLszkOpPRZIjm1
         tKsBAURwcGAFY6iAwPRM/Yemo0jA0ic5vsLvvELqsmppKomnXYjDCcarAb3bwKxMG04K
         +gIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3CTbQj7+T5lQ2eAoPyur9Oo1co6LLPaOcAEjbkl5sM=;
        b=FgLyi2bDAnuU7l/ktaIFto1dtNeANWLWTjQzQqDBn9BEpbsfwMw+8rbhAn13YeT387
         28E3W9z3nJSLoadNiSAFsBA3CWNjSp5uTYkiP0igl5DH+5Yyx7Zm4SRdDdN1M/ZZDCrX
         r2ERuJiy+Fhr1Xf1/DqkjZ9D8+bWLGjxaB2GKZn81tDpIOsKRN5h8JKQ2Vmk0BLZkYci
         gci+xyR5skMnOVbKpOmtF2wLX6nps7BhU3DSrGmm4wwBMVf7DVwjBKEMF6zaEAVRMrMG
         cYqxbHwkY0SmhG7+VbTRKjF9/cGQ9yP1+D2s0G8nobQjRYgl/+BFcoGHjBAC4iOSuA/m
         3h6w==
X-Gm-Message-State: AGi0PuZBgc5xEuaOAgQMBCpnBroNUNtI4uDhzM4EQgnfKZ+/4zeiP+FO
        Yv6lcf35DPBMc2xOm8U/GO9seS9P8CHADjkuy3o=
X-Google-Smtp-Source: APiQypI1VvZV7PVtdc83u0cMwUfVgDNFRErDe60mASwbcaKyck2/BWrLeLTsyxCvuQgsOh5LZDiVTSTpP0NJrZQLbTs=
X-Received: by 2002:a17:906:add7:: with SMTP id lb23mr3149739ejb.6.1588689353347;
 Tue, 05 May 2020 07:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200503211035.19363-6-olteanv@gmail.com> <202005052245.XuBbZqBH%lkp@intel.com>
In-Reply-To: <202005052245.XuBbZqBH%lkp@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 5 May 2020 17:35:42 +0300
Message-ID: <CA+h21hrLiXuWFqPd-qrbfGHdF1tfMJR-o8wWp8x3RbYdZs824w@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] net: dsa: sja1105: implement tc-gate using
 time-triggered virtual links
To:     kbuild test robot <lkp@intel.com>
Cc:     netdev <netdev@vger.kernel.org>, kbuild-all@lists.01.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 at 17:26, kbuild test robot <lkp@intel.com> wrote:
>
> Hi Vladimir,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
> [also build test ERROR on net/master linus/master v5.7-rc4 next-20200505]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/tc-gate-offload-for-SJA1105-DSA-switch/20200505-040345
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 627642f07b3093f501495d226c7a0b9d56a0c870
> config: i386-randconfig-h001-20200503 (attached as .config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/dsa/sja1105/sja1105_flower.c: In function 'sja1105_cls_flower_add':
> >> drivers/net/dsa/sja1105/sja1105_flower.c:406:9: error: implicit declaration of function 'sja1105_init_scheduling'; did you mean 'sja1105_get_strings'? [-Werror=implicit-function-declaration]
>        rc = sja1105_init_scheduling(priv);
>             ^~~~~~~~~~~~~~~~~~~~~~~
>             sja1105_get_strings
>    cc1: some warnings being treated as errors
>
> vim +406 drivers/net/dsa/sja1105/sja1105_flower.c
>
>    303
>    304  int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
>    305                             struct flow_cls_offload *cls, bool ingress)
>    306  {
>    307          struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
>    308          struct netlink_ext_ack *extack = cls->common.extack;
>    309          struct sja1105_private *priv = ds->priv;
>    310          const struct flow_action_entry *act;
>    311          unsigned long cookie = cls->cookie;
>    312          bool routing_rule = false;
>    313          struct sja1105_key key;
>    314          bool gate_rule = false;
>    315          bool vl_rule = false;
>    316          int rc, i;
>    317
>    318          rc = sja1105_flower_parse_key(priv, extack, cls, &key);
>    319          if (rc)
>    320                  return rc;
>    321
>    322          rc = -EOPNOTSUPP;
>    323
>    324          flow_action_for_each(i, act, &rule->action) {
>    325                  switch (act->id) {
>    326                  case FLOW_ACTION_POLICE:
>    327                          rc = sja1105_flower_policer(priv, port, extack, cookie,
>    328                                                      &key,
>    329                                                      act->police.rate_bytes_ps,
>    330                                                      act->police.burst);
>    331                          if (rc)
>    332                                  goto out;
>    333                          break;
>    334                  case FLOW_ACTION_TRAP: {
>    335                          int cpu = dsa_upstream_port(ds, port);
>    336
>    337                          routing_rule = true;
>    338                          vl_rule = true;
>    339
>    340                          rc = sja1105_vl_redirect(priv, port, extack, cookie,
>    341                                                   &key, BIT(cpu), true);
>    342                          if (rc)
>    343                                  goto out;
>    344                          break;
>    345                  }
>    346                  case FLOW_ACTION_REDIRECT: {
>    347                          struct dsa_port *to_dp;
>    348
>    349                          if (!dsa_slave_dev_check(act->dev)) {
>    350                                  NL_SET_ERR_MSG_MOD(extack,
>    351                                                     "Destination not a switch port");
>    352                                  return -EOPNOTSUPP;
>    353                          }
>    354
>    355                          to_dp = dsa_slave_to_port(act->dev);
>    356                          routing_rule = true;
>    357                          vl_rule = true;
>    358
>    359                          rc = sja1105_vl_redirect(priv, port, extack, cookie,
>    360                                                   &key, BIT(to_dp->index), true);
>    361                          if (rc)
>    362                                  goto out;
>    363                          break;
>    364                  }
>    365                  case FLOW_ACTION_DROP:
>    366                          vl_rule = true;
>    367
>    368                          rc = sja1105_vl_redirect(priv, port, extack, cookie,
>    369                                                   &key, 0, false);
>    370                          if (rc)
>    371                                  goto out;
>    372                          break;
>    373                  case FLOW_ACTION_GATE:
>    374                          gate_rule = true;
>    375                          vl_rule = true;
>    376
>    377                          rc = sja1105_vl_gate(priv, port, extack, cookie,
>    378                                               &key, act->gate.index,
>    379                                               act->gate.prio,
>    380                                               act->gate.basetime,
>    381                                               act->gate.cycletime,
>    382                                               act->gate.cycletimeext,
>    383                                               act->gate.num_entries,
>    384                                               act->gate.entries);
>    385                          if (rc)
>    386                                  goto out;
>    387                          break;
>    388                  default:
>    389                          NL_SET_ERR_MSG_MOD(extack,
>    390                                             "Action not supported");
>    391                          rc = -EOPNOTSUPP;
>    392                          goto out;
>    393                  }
>    394          }
>    395
>    396          if (vl_rule && !rc) {
>    397                  /* Delay scheduling configuration until DESTPORTS has been
>    398                   * populated by all other actions.
>    399                   */
>    400                  if (gate_rule) {
>    401                          if (!routing_rule) {
>    402                                  NL_SET_ERR_MSG_MOD(extack,
>    403                                                     "Can only offload gate action together with redirect or trap");
>    404                                  return -EOPNOTSUPP;
>    405                          }
>  > 406                          rc = sja1105_init_scheduling(priv);
>    407                          if (rc)
>    408                                  goto out;
>    409                  }
>    410
>    411                  rc = sja1105_static_config_reload(priv, SJA1105_VIRTUAL_LINKS);
>    412          }
>    413
>    414  out:
>    415          return rc;
>    416  }
>    417
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Whoops, I forgot to provide a shim implementation
sja1105_init_scheduling for the case where NET_DSA_SJA1105_TAS is not
enabled.
If there are no other comments I'll send a v3 soon with just this change.

-Vladimir
