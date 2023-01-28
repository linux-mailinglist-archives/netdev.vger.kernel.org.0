Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD5767F7E8
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbjA1NJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjA1NJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:09:58 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2092.outbound.protection.outlook.com [40.107.93.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEACC641
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 05:09:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuX0CYXfm6uG/EzA1l47VyX03u61hJ7ivAjDxf8kq9tiFwacJh43Ocin3K/X7dzlgIZ1FpK2vKJT7kwVrxHIcnC5my/ZXC/94c/Gklfz8HUe/rQL2lzzw86TEAT8VMSSV5czRfhMOEGKs1i9EPaRd6MZO8QkWkhXVSlNBuBdDMq3kvfE9eF9nSgH+R9NAi5mkJLQa88i0JtdcKxC1OGDRGzypYqpSOCNSnAf3dCmJs/uDEf2Uox1urTqEjgKjCnJIMG3+Zi1RaeSO0uqlS3g9FfSCUCRz9a8UboXUgsriQTMS7UNbNuWB8zVD6Z4SjQ/MIEl8QfCNid2xO7CLG6BYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ONIq120fqzyQ645tBFu+LVJn67b/FO5NVfMutATYiw=;
 b=kLZfMN2sa7Yx0DL/CbTHXe1DSID/3CVXEghvYmCbRmsKvbwle8aTQW+T9/LoOmZvuRrWWpHmB41ri+v6bbc5oLqGipXE2eGl80gITysrNzJxi10nYZccbgg9LQZNmSGxQCS346aI3ms9RwM9JoZNlWwe+lO66m80s892IqSTHJMZUTbult/GzLqOeKi/BW7mfUayxw38LaUUOCJr6hB1NxI3QKegXg2+oaXipJa82HdjprEEfs+yn1Fpe3I5EbmolZ1xmp4zeynOsnJxxqpbxTweBJTLKupFf6tTIuX8Te1R8pnplFtIELweuMqws66Jw61iMktgTKSeSaW2IOzQaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ONIq120fqzyQ645tBFu+LVJn67b/FO5NVfMutATYiw=;
 b=DgJ9Kf5OhxFqT3swP1xnvSo+GuhjtKv4jqIywp2Gp5cjg5/WKwjJsWMUKrTUxgzOjJGbQmXe6VfqXRzJaDa2CVvgjYGoZP+WrSR/hAJNmggSYjbEuqkQzODcfF00nbfJWfUt4RhThtioQaQalp0BKDZJ5rAGkTOYzlIy6jtJ1vU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5485.namprd13.prod.outlook.com (2603:10b6:303:190::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Sat, 28 Jan
 2023 13:09:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 13:09:53 +0000
Date:   Sat, 28 Jan 2023 14:09:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v3] net/sched: transition act_pedit to rcu and
 percpu stats
Message-ID: <Y9UemKFXoekIISvC@corigine.com>
References: <20230127192752.3643015-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127192752.3643015-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5485:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a546b0d-3b72-4f2f-d473-08db0130f1f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuMVnQ7Zsp0tlRbwqSfoSzN46/WNWKjRz0puluUbQ0KbNqgdkEhtZG+jTHSMIlfS3GSCFFqE4ULm50zEFnp3qCU0/nInzlvtWuM75OK2JTfAjgttqyL7tINNKDaAXUEec+PdAIK6izPx+kcURiEzZ1Ivms7kqe/1chhy8z5pD8WCTHmkaIxAwhUY2eU2T2giG1pby/LHAMJlzAMeR4O793sKSFOPd+gIrPzHsnxbt5Kdy09rnJXwCHbhVSzIHuUvbCYOySJnn35NtUofZ4168H5/RW7i23Tpojhw+Kk3RVjHdrxi3qxjRFg+MO3kxH+xmllY5LgJl64P4xl+6KKHpIcjTJehauwZcOYiaRIuQq91hxBuTQrZaEmgkgPSQuiGaL+nnaaxbpFTPLcbLpWTNVUGRNDIZ+gK8gLNqE30I2XI/g+juUZFUTMR7xWSLNslhdl2teiFOwGG7QyIxt4WNdvB54jxSemEiW03K/jedQ7GqCzZUufjRf78wVSjSLKLuQUa9xf6fOM+DNpnfoMZrAOfS5Qpu6N+H5YFC8Y52SlWICh+YuVSVK8FQv1tYNfrHdTndSyTWCg4Dlw/ZSXT3he2v5/8+zRgSK8sufXiU1AqOLCBgAsiWeWfiCwJlSt1VhldoolhbyStN2dnS0Q+VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(136003)(366004)(376002)(346002)(451199018)(38100700002)(44832011)(86362001)(36756003)(8676002)(2906002)(6512007)(66476007)(66946007)(8936002)(41300700001)(4326008)(186003)(66556008)(5660300002)(6916009)(2616005)(6506007)(316002)(6486002)(478600001)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5E66PmBETYz2nApNqVA0YvtnA4RBXRVvdL7fVsX1qUSOSBYNiPcJYYUuUW1y?=
 =?us-ascii?Q?nAMVZwDMF9a7fneRKjNpyyyvgTsYIOQLgb6qdVB1KrngmUY9eWUe9X0MbpsE?=
 =?us-ascii?Q?EoXqyRRct+hyIezUiQ5bfQ+2lZXM4UrONmMHiuyV0COA1BDyAi8Ay/EyfQRZ?=
 =?us-ascii?Q?2jKT5MeE0X+RskmqzkqLGvYzqKoOxco/UNxDLDTg5aj96beP6q9ykwA+94Ht?=
 =?us-ascii?Q?V6uwsndYQOofH115KBktf2P78V2vubfS5YhweeIAnoLsJophylH1UtcqTP0l?=
 =?us-ascii?Q?fSRcmrglV9mEA9nElRltRYqh2Q8n1TqETYcod89AdBYo46/yzX2IsVVcUCN1?=
 =?us-ascii?Q?+brS6pg3WQ7z0pWH5VLejFGQTLwY/3/Fpto0q43B8UyaGizPYZgG5gKa+2S4?=
 =?us-ascii?Q?YX8hs83fYlTt7RbHkcckpaa8ELWdMIuoP7XiIHMxy1udKWPKrHoFpJ167sqx?=
 =?us-ascii?Q?4aPcyMao6hAsDLGXpHrq6lJlSBashwIMLfRHLmTeKsVKZqxM+DsUa+0F+LLw?=
 =?us-ascii?Q?topuFYUMGVr/1Ep8oIxblWl/2U9M6Hbwi2iwcBjOiM93d3W4d+SgQShxM+uy?=
 =?us-ascii?Q?hRQh6kkebdPW4+EsUDP42xPenVJHGHWizgoZhxX3cvw05jCj+b9icj8k/SOg?=
 =?us-ascii?Q?EVTrDNDy0oMxjBGCFmgdwNQ7ujWijEvtEGjn0MbEHld5Id1lI3QQTCycIwd6?=
 =?us-ascii?Q?iCKrqARquN2qxb88ITZpWG6SwCrO543D7vvYeSrE2NvnN/UteEKrx6rIIv+J?=
 =?us-ascii?Q?Ae8caoOlxChVsXK9b06h06sm1HYrucId+b+TCLjTAjuTyQXpcdT1vtTQIGww?=
 =?us-ascii?Q?+zaoN+eSYTHfxRb3UBsAsMUFNOc+rg/1GSKGGzUgS0C2lhKi9ybmKrKdyl5h?=
 =?us-ascii?Q?Uw7sy32fMH7E0ugTU8wRXFkHMhqQrKNh4ryVkKXH7LSxg/glFNX29/fyHHbM?=
 =?us-ascii?Q?xvHu+cCBZ121+0HHMS9337XGq5UJHKnMq2JqPsO8KSj82IeiogteFy1dnYxO?=
 =?us-ascii?Q?qAn4DfQNjYQh+IBXQNl+sQGyr+EXS6LZKdIlGWHuQOPSzQ0/0ZSd+XqoXVI8?=
 =?us-ascii?Q?WPTbTigGb+9nKReNXAKr/Ryh0yibF4fdSqunMXgY21MbjywRpgR7GTrB4inz?=
 =?us-ascii?Q?jGo/Gea8dyOxCOJQRoL2vYJiUZWj2JfGOJ2tM8uFjZo+L3CPHwzXUmOh4cWZ?=
 =?us-ascii?Q?S9CB34nkGq+wWLCw7kygl/C62hfwPiUT9MOnmAKUWL8+fRkba8PJeYxF+gaO?=
 =?us-ascii?Q?LhMXi6WHkj51Hbf9t1Af5qtqjwyWwVYl0FFMiucJLsF6MgUflQw6hF2XzffO?=
 =?us-ascii?Q?59DlVvEppaYzVJKerRXtnSM+CmapORobvI0NrU16nvM3SlEwbooV4/1g/djg?=
 =?us-ascii?Q?a1E+XVM4YLBK2hCRa1veJr6xsI02PtRXKVOUDoNL9oHZNso2K1zaXj4ZNToQ?=
 =?us-ascii?Q?EjQro7P4AGlv1strAGjgn7GVzZ1GSpWH+RtQ3aJggo1WSAbPefm1BFrqdXKu?=
 =?us-ascii?Q?fJPx9gfaFUhAIeafzK1XulKQWn2vBxJ7t4g0LgXCY47JNUvj7/pVPTqCXiwN?=
 =?us-ascii?Q?QtnXzW8N9ZOehhgeOdm0ZfBaJLaS77t2i2F/6Y2oIUOMvcUvipHfO1f/rR0k?=
 =?us-ascii?Q?Vx/n0WhvAWS0zKLGIEjukSfuoSKbCLPUUHY1mbLZ293iGcuVD3wD3tvt/MUm?=
 =?us-ascii?Q?eYO/Rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a546b0d-3b72-4f2f-d473-08db0130f1f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 13:09:53.7171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lSUc9MUWPdH7aNByvOMvjYRcitEYlpsA1oDkS+w4kk3lBFE4+v61+0rtF9UlXyABC1HtX8zaRu/LAF++/Cy61TSmUZTzzVg6MHbWeAaySrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5485
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 04:27:52PM -0300, Pedro Tammela wrote:
> The software pedit action didn't get the same love as some of the
> other actions and it's still using spinlocks and shared stats.
> Transition the action to rcu and percpu stats which improves the
> action's performance dramatically.
> 
> We test this change with a very simple packet forwarding setup:
> 
> tc filter add dev ens2f0 ingress protocol ip matchall \
>    action pedit ex munge eth src set b8:ce:f6:4b:68:35 pipe \
>    action pedit ex munge eth dst set ac:1f:6b:e4:ff:93 pipe \
>    action mirred egress redirect dev ens2f1
> tc filter add dev ens2f1 ingress protocol ip matchall \
>    action pedit ex munge eth src set b8:ce:f6:4b:68:34 pipe \
>    action pedit ex munge eth dst set ac:1f:6b:e4:ff:92 pipe \
>    action mirred egress redirect dev ens2f0
> 
> Using TRex with a http-like profile, in our setup with a 25G NIC
> and a 26 cores Intel CPU, we observe the following in perf:
>    before:
>     11.59%  2.30%  [kernel]  [k] tcf_pedit_act
>        2.55% tcf_pedit_act
> 	     8.38% _raw_spin_lock
> 		       6.43% native_queued_spin_lock_slowpath
>    after:
>     1.46%  1.46%  [kernel]  [k] tcf_pedit_act
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

Hi Pedro,

in general this patch looks good to me.

In the course of reviewing it I cam up with a few comments which I have
provided below. Please consider these as being for informational purposes.
From my perspective they don't warrant a respin.

> diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
> index 3e02709a1df6..7c597db2b4fa 100644
> --- a/include/net/tc_act/tc_pedit.h
> +++ b/include/net/tc_act/tc_pedit.h

...

> @@ -32,37 +39,81 @@ static inline bool is_tcf_pedit(const struct tc_action *a)
>  
>  static inline int tcf_pedit_nkeys(const struct tc_action *a)
>  {
> -	return to_pedit(a)->tcfp_nkeys;
> +	struct tcf_pedit_parms *parms;
> +	int nkeys;
> +
> +	rcu_read_lock();
> +	parms = to_pedit_parms(a);
> +	nkeys = parms->tcfp_nkeys;
> +	rcu_read_unlock();
> +
> +	return nkeys;
>  }
>  
>  static inline u32 tcf_pedit_htype(const struct tc_action *a, int index)
>  {
> -	if (to_pedit(a)->tcfp_keys_ex)
> -		return to_pedit(a)->tcfp_keys_ex[index].htype;
> +	struct tcf_pedit_parms *parms;
> +	u32 htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;

nit: reverse xmas tree for local variables: longest line to shortest

...

> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index a0378e9f0121..1b3499585d7a 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c

...

> @@ -324,109 +352,107 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>  				    const struct tc_action *a,
>  				    struct tcf_result *res)
>  {
> +	enum pedit_header_type htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
> +	enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
>  	struct tcf_pedit *p = to_pedit(a);
> +	struct tcf_pedit_key_ex *tkey_ex;
> +	struct tcf_pedit_parms *parms;
> +	struct tc_pedit_key *tkey;
>  	u32 max_offset;
>  	int i;
>  
> -	spin_lock(&p->tcf_lock);
> +	parms = rcu_dereference_bh(p->parms);
>  
>  	max_offset = (skb_transport_header_was_set(skb) ?
>  		      skb_transport_offset(skb) :
>  		      skb_network_offset(skb)) +
> -		     p->tcfp_off_max_hint;
> +		     parms->tcfp_off_max_hint;
>  	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
> -		goto unlock;
> +		goto done;
>  
>  	tcf_lastuse_update(&p->tcf_tm);
> +	tcf_action_update_bstats(&p->common, skb);
>  
> -	if (p->tcfp_nkeys > 0) {

nit: It seems to me that this patch removes the above condition and relies
     on: 1) tcfp_nkeys not being negative and 2) the for loop that follows
     being a no-op  if >tcfp_nkeys is 0.

     If so, it is nice as as it reduces indentation and in general
     simplifies the code. However, this patch does other things, and making
     this indentation change at the same time makes review harder than it
     might otherwise be (for me, at least).

     Perhaps there is some reason that the changes need to be made at the
     same time. But if not, I would have leant towards breaking out the
     removal of this condition into a different patch.

> -		struct tc_pedit_key *tkey = p->tcfp_keys;
> -		struct tcf_pedit_key_ex *tkey_ex = p->tcfp_keys_ex;
> -		enum pedit_header_type htype =
> -			TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
> -		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
> -
> -		for (i = p->tcfp_nkeys; i > 0; i--, tkey++) {
> -			u32 *ptr, hdata;
> -			int offset = tkey->off;
> -			int hoffset;
> -			u32 val;
> -			int rc;
> -
> -			if (tkey_ex) {
> -				htype = tkey_ex->htype;
> -				cmd = tkey_ex->cmd;
> -
> -				tkey_ex++;
> -			}
> +	tkey_ex = parms->tcfp_keys_ex;
> +	tkey = parms->tcfp_keys;
>  
> -			rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
> -			if (rc) {
> -				pr_info("tc action pedit bad header type specified (0x%x)\n",
> -					htype);
> -				goto bad;
> -			}
> +	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
> +		u32 *ptr, hdata;
> +		int offset = tkey->off;
> +		int hoffset;
> +		u32 val;
> +		int rc;

nit: I appreciate that this is just changing the indentation of existing code.
     But it would be nice if it complied to reverse-xmas tree ordering
     and consistently either a) had multiple non-assignment declarations on
     the same line or b) one declaration per line. e.g.:

		int offset = tkey->off;
		u32 *ptr, hdata, val;
		int hoffset, rc;
