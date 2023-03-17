Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B196BEE81
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjCQQiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjCQQiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:38:09 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2105.outbound.protection.outlook.com [40.107.237.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2E08ABC9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:38:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGXHSJO+eSoNqM4NCOkE584xcuGxbwfoyHHn7CD6Rd7fb6Jv1M4HDgRM8ZBz5WJeIBpz24fTj3M2pDv4SUYgPZM4YMiDWD1JO46AgFn7V7ByOxyw64xF1Wpe/5wpXtARc39esKOw916YjHuW25j6VfcxAAXdgk5ioOnNSB+Pnwia0m6r7xLtKyEKQyIIwHnfNpUNt+jB7kbmnPcxzU1g6w/9rcYi50qDNOmc5S+heq+GFy617sri5JKm/7CBs9AYfNYjJWIwdBvtpwF2o6REUhU1Vda4rIPgmKQErsxtwmo6MAu/r5zJr0/GY5KlXy5OjQzT5wL9emjKby08LrGv3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMAXH33TbdLirJNe1vSYp6XmnZvLseTcANKXyPaePVs=;
 b=iKaAy6do0ZJeJvR/JZZV11ebHMmt+xcyWFvCl9vXjkWhvGWMwWac41+EBE12QKC46HolKSPjJMqKBVKuCXyLDlB5zg1NY3lIL3X4L4LKlOrJ2PGEe7c4veGzvNH45yT/CHFaMvP7SyngIx6h3sHgeWkGFa0XyEggZF+HNEihNfrlJjKPgCr4tkWnnw030s9mgiDYUUXK5VIoAEKVSAM8Ev5tOQIZ8XZRC7Q/7sv1Nu8Sw1N7b6F/Rquz+y/KCu54SOJL/el9uMsUQSLXxIreoVwZmcU1XPbTTG6Wq2mxKPMSeeX4Q65Aa9Rl5RvNEtI2SM+bgZOkxHS4MHTu59V+Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMAXH33TbdLirJNe1vSYp6XmnZvLseTcANKXyPaePVs=;
 b=ga+jd/XXNUCI2fD8JdNEMpheAskokpna4iQBiLZbcL6jrpx0zn5aE/k0Y4sut34TfgObu4FEzyUBJwa+BWoboWGdTuYvhKDPvNcn1rZXZroulE/pkY5wCqo7S0K4wMA5Dvp4jZUDFVtxjkCmfPejJ7BAmDeu7dSL23vWvy5FxhA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4919.namprd13.prod.outlook.com (2603:10b6:303:da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:38:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:38:01 +0000
Date:   Fri, 17 Mar 2023 17:37:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 06/10] af_unix: preserve const qualifier in
 unix_sk()
Message-ID: <ZBSXY0AtOcrmug+L@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-7-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-7-edumazet@google.com>
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4919:EE_
X-MS-Office365-Filtering-Correlation-Id: 02981117-9da6-45ec-3d0f-08db2705f92b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KSGhs2bR5CJZLNqhhaNc6QEU70nZ0v/L+6dsM4xJBnVo7t6xYdXyC433nQinM0HURgatvyKbju5KPjaUEzU1KIc8ArGTLhxCvI+tocJb95CMcIim7mD+MKssNUvY23bADcGezQw0iAFNFcw3ztBJZ/3XsZ9yAt0u1YbTODzdiLNmZ/HbWf1dup9PHBFngECzREqcnzSonFxCt1Uxp+ipbxSgwDe0MCoEhuLa/ujJcNNeDddqIfQuHpQa92N2TZJ2MC13bg1jvPWA2+9vElhQY+9F08sSG+K/wgYJNrTF/5oeRFxFpg69NktaYqUS40IEwoG6tgFoofMyRlTUMW3ARhcSwl0BYiDVmheQ1XzPaTZNjLlXSwSbrTXtEWuPKnmwt2C2kmlwZmoQjh70t7UGmvH8w4Xm/+3H9WHCSEIFt7gd/7sXaiYwR6rgOpHw8IHKVtp6pIqTosmQgKHhPwUkbQWvqY9mjhd0MC74ugQIsLTEra+g0lXal2ayipN4f3TPLvO1v66Iyt5cRmtgBIbPU6DsGwBt1tK/tysNAMDntW9b5/x/CfvKChYpmwvU1RVer/ZJ+To48EnqS3cldmmVL0WpkflcKEElSQhSNCpKxwQpW5/WSL8QQZEHUZU6wuAKSyXAz0YYVcNjpWWoBs8sx/0sfzbmAZa6Yhu1L8kTtrJW10z2KZGlMq0R0RemSdEv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39840400004)(366004)(451199018)(38100700002)(86362001)(5660300002)(36756003)(2906002)(44832011)(41300700001)(8936002)(4744005)(6506007)(2616005)(6512007)(316002)(186003)(54906003)(6916009)(66556008)(66476007)(66946007)(6486002)(6666004)(478600001)(4326008)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SjStNHVrnOYPC0MbmKc0kUL1oef8ppmYvlKgzg44ENj7XDMzAVLooqS6BYGw?=
 =?us-ascii?Q?tdTHA5vSC09B2VBb3FAK2TEcHJefM+Oc5XQvUAY1HCYEOHrlNnfv+s4Lq2M8?=
 =?us-ascii?Q?bX/DqaoZmTWEgXga8F2r0VIpG/4sgRsGKECYyNuXWfMX8ykAX71Gt1oberBf?=
 =?us-ascii?Q?tr2W6mdybJL8kKXxNspN1wLrsVSSlLs4bNmuGLyD0pFmSnvfh4EBV1n0SCwa?=
 =?us-ascii?Q?WBZSMcVMl9DIET79B+9VTYj0bmu3X0gGa0xNG7pjxcQc7uf5R4G724rvHpVe?=
 =?us-ascii?Q?mqS77WpVkMa60Pa9ietn//AFDDceI5v5FE/cT+Ca7tsMhtAC35k5ofcpATap?=
 =?us-ascii?Q?jPVfn3RHUU9GUAM4lKmC1j28Bdf3SoHuYA5qKCXc6UND9A3ppexNmWn3j4k/?=
 =?us-ascii?Q?yHF4zj9GdiDvwpabA+KL6J8RItMnIbi9j30C0ecxw7yidujd6B7ndOnhY5rr?=
 =?us-ascii?Q?WFh72pzfRm4S27lWR7KEEj5QpLBz0Wij4Ov+YgKP46W3qfT2RFx0YOGGX54m?=
 =?us-ascii?Q?GBcDxm1ZyX12m+V8Mh31FHBDqQ75qks5gfpyXtpkjyjeX4GGsSmKSl1lSdMR?=
 =?us-ascii?Q?egPfMK7ecJ0NrPkqUWjGTn77RPuLQAgYUmALgi5FVn0Qs0bASfCJhuQdYrMK?=
 =?us-ascii?Q?646+00pKe/gzjCfb01+xW5Rp8Rp4VNcN3i5UyuQUwHJXpAWH83CS95lPA2XT?=
 =?us-ascii?Q?evTpwmDSONlkMehfTq5PIFYSyVZFlG+0zlmaYFLJguyj/544TYUb+XY32tCi?=
 =?us-ascii?Q?YaSIlfgFNMwexFZpPj0TdB5qVojMopZL7cda/TUtF0CUx50XMGFYhk1bOMPS?=
 =?us-ascii?Q?UVQDebv7ReRbecmf936HpcWi9yZEtFhH6BMiKpvw7wnoXra6LTO6SPF3ICfo?=
 =?us-ascii?Q?+/2ZzTdFVPAxBDhFyYUOkG34mTbHOfdN/Acj5XkDdHDPcra4oOXZ27pnWM/g?=
 =?us-ascii?Q?osfzZfWUJFWB9yxhPXEgJ2ZYd7AgZ2XbYPaX66CIZMmYO9ZW5kmZjDlTKxDh?=
 =?us-ascii?Q?zor7rGp/L9zeBys8QnGuPSy9HBdqfyav1Ap1DGl2z93OXXPRmUKzHKM+gaNV?=
 =?us-ascii?Q?OgzikNQnayQFtZooEp+OZA/L3hrXqSL9J31TFqnp/MGwiPr5nHvBoNvud8mJ?=
 =?us-ascii?Q?CRTzRyP6SJbFfqHtHQkTHXAH9Z/B6c35Rd3eqHXRxhiyf5OX0/2C4SJithOV?=
 =?us-ascii?Q?/eWzjze9TBzV8T+zARC1a7/To+XGu2rOjuuAMw1whqGNhyLqTDfSA2sLusA7?=
 =?us-ascii?Q?3h6Y63akbKkaAZcpavHtWOqcUHFmZQ2W3lPRWzfTbbcx1Yuwx3zpZLy4iI7M?=
 =?us-ascii?Q?YDDDD0wwHfXp6iWv6TC3hEosEIcZWv7l79TtRcfvnXdiKxkthz6idi6gZ2n2?=
 =?us-ascii?Q?HtobAOPyBwOof/GElahTv8EadKVSDVpU5Sqovm8Zq4r2IdNWSTNp3m1X9Q+j?=
 =?us-ascii?Q?UYqarUtoRQ4DDvwHF+M9IWG/I1oIMTXXst3MFD05SmYkV3yB0DPdw6sEZdOa?=
 =?us-ascii?Q?UCNMQq5ebQSBzgAOVHQbNqsvWkiP3MPDjvcCIwpkR8ve0Ogc12COQX18lfma?=
 =?us-ascii?Q?hDXZNtAyQabN9jCMHLqptzI72UFjsz8yU3C3QTmAnU+8L/xPAjKoQvox19UE?=
 =?us-ascii?Q?AmRVW+7y5qN6enRQ1qyjwcGP7vhFEimuVh3AbNIwfjCZaLivd5If5h2o5zVS?=
 =?us-ascii?Q?yNJU6A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02981117-9da6-45ec-3d0f-08db2705f92b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:38:01.3299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BPdKu8dJQWsSF6EryXYmGxbCH0q8afI48+S/Nip04SZ5kIVNbnEKRruxtDA7l9mngae87ZzXXJetgP8+yuf7OJJ7LgWIuA8hXiKIxJuP5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:35PM +0000, Eric Dumazet wrote:
> We can change unix_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> We need to change dump_common_audit_data() 'struct unix_sock *u'
> local var to get a const attribute.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

