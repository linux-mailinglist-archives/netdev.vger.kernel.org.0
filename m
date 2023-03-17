Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416E56BEE6D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCQQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCQQfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:35:43 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FF875A76
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 09:35:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUaf5GMQn9l2vo6XFsNzQPtyEBW0LAI87KzLDcvh6MiGUpvYbn9f9aOR34k+xLjUWqdojagpQTWn0Mx6Y82KH8Hp5P3duxUuX5KekkkJ+yZ/GlZCFOfh4gBQsDIzRZyq9QA97D8GgvZxr8vLN0zJzsQBr9nmKt0WnybvigzWkkTsruJ/Apd6cbw6b6H1V30VrslTJ+TNTmX5ig8eE2a7vKyLbZvEehqjVcrlDwOAapAlBlas3A7jtmlx3KK/NcymjHOGG2anpBj9w49/CHatuXEVbMFTH2nid23VUQWtstaNjreHK45pcrFiMBEkXEd0psh58iymj6uOfnUn/mxmRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PEZeazSlln5in+t3pCUFs+aB0rqWjvYoYT4Po4avWE=;
 b=Iz2CuVip/8Sl3QJ31YCn4I60B1biT8uhTUfgDoR+jWME5cDBHw/RK2HrX/2VmKt41fZZEPQOCJhnyKu/KR4BpPGdkUT82rUC+QjapWiwWBHLKsvNnG/bEeXcScG90UESadl25Nb5Mp05iC/GL00zrmbrbFcaEQheIpGjsBOSMYvWZJamr8JR4X3HCkj7DmOTanh6RecR2qlKn8cPjDHBIyUfry2LBlmNeK6K056qdQulQ7+YYt84Mjkm1PWpjsdUvFVdpKI9MdQDTeL81NvTJDWwxbE/9xB5EdmGT68f7i6+vXIyhHyxymrbDr0f6CnnAvnTG/cAgO/3KpA9dtDBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PEZeazSlln5in+t3pCUFs+aB0rqWjvYoYT4Po4avWE=;
 b=odSaGRb5SGDDudYny//cWbMNYU8l2HkfV1Kx3XSasGR4vPV8OjFB/nMog408ykS6cw78wN1Gal6CAyfanmep5Iq7h79k6MFXhS5CvCY/4ySH0s594Zc4m3ZuGOByfz2InGvBm95PDjr5MUHENIOkuS7PgW9wd8kUzDlSpcTpYX4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4919.namprd13.prod.outlook.com (2603:10b6:303:da::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 16:35:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:35:36 +0000
Date:   Fri, 17 Mar 2023 17:35:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 04/10] ipv6: raw: preserve const qualifier in
 raw6_sk()
Message-ID: <ZBSW0ddxgM2g4jQH@corigine.com>
References: <20230317155539.2552954-1-edumazet@google.com>
 <20230317155539.2552954-5-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317155539.2552954-5-edumazet@google.com>
X-ClientProxiedBy: AS4P195CA0004.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4919:EE_
X-MS-Office365-Filtering-Correlation-Id: 2275a67d-2d24-46f5-801b-08db2705a283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8ZP9VjNUt3J8/1uCpAQmbD+YphVXZDMGyyz7D6G5vi82syw3gY2af02DsRVXeVk68Gx23hEPVGnq+035Oj1QtBlIPKJOKVcrKwmOcBXzPKGygdZAC4mMzrxA9B+HfeurcItCK3kMVH2q7f3ab6suzx3Qa/c9zQLhSg3y+Tjg2LASzKt2Dij2o1OJ2Ju+QB66aq9M3KWMLwYDdZdkBV0BPXFCN+ffD+j6Z5RKiUIow8i9Cn4DmCUdU23ql0VCfp+0/oLlN4NhuegNx+U+Klr5wprg1WXCXyy5su4ejy0mQmCUno/wbfhAZpuQfeLi4ZKRiRiey0NRq43Q1utkVFg3IBI1/9vXrm7VuooQ/ljs3L9DkGLHzCvf6PhhTFBSP1eoliBdw+VnA8h398KefeQrRrukYRkS9v7f7/Xv9og0yIea+FgrnsZXGsudWkTnVb63eMu+EIAHkbWwkKFA1+bGKDVSNAYtAdT90yaUgb85VU9DZMBNZvg/k0JziS3lF7v3dxPAEJjc1pgWCjkEDjT+i+MoMJczw88lo/xGqjR5CR+zQIPYLiSp/vML/oEqEZh3zVIi098tV8eR/arv97sLzykLyALKIasSJWesw8UYy4bGJBYsfpaV/gz9QOYudqq5UjGNtcNu3geBkbQCi+L+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(346002)(39840400004)(366004)(451199018)(38100700002)(86362001)(558084003)(5660300002)(36756003)(2906002)(44832011)(41300700001)(8936002)(6506007)(2616005)(6512007)(316002)(186003)(54906003)(6916009)(66556008)(66476007)(66946007)(6486002)(6666004)(478600001)(4326008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U53Z7LSkYid8kc7ofuq+j+PS3YFHxUc+Npyn/9mRmOMSPar/mhA6UHHgRv7A?=
 =?us-ascii?Q?NG13ON8cdPJ48teij4K3wH6ecOOW0i7NxMUqRC4gZ6XEpwnvc1uZPVT5n2pP?=
 =?us-ascii?Q?jBYuntFFYSd1gfcg4y3pz2UCm/pfmpK6BC5gWayHLQ0ATbtJhDXXg9Yzq1Qn?=
 =?us-ascii?Q?s04FBKOiZSHgHcWoK0Z+HgFQZdFZ9CydWd0ksiNbieOyE6HIbFG+S3zoLaV8?=
 =?us-ascii?Q?vvsiRAqQFVobexpzSYyn0Va2+jIT9QF1k+ZzPBqiAmZxdXATI3llljlW0IHs?=
 =?us-ascii?Q?49ZtOPVfIDhq0Ir28PsdcIYh305TfGga/OlZPp0rmVW/KPfoTmCV/Ub4rydP?=
 =?us-ascii?Q?OasOzQxkxmAk2sCo8TaD9Eu34OhZSTM8e5VYOl48wvyUI3YX1MX6B3hmfAxj?=
 =?us-ascii?Q?rIoB8a/5Gbh0EZKl/uSceweTKSEvyZOMZGfdyvMmw8t5xUb1b235GQsGWjun?=
 =?us-ascii?Q?Cx+yOAAaUlLktF8R+p0/ZXlRXPs2TVMZdc898fsQ2M7lpe4sJdMQge2Gl1yL?=
 =?us-ascii?Q?HaZxmib3udis2wThY2xaTfPzHNWazABOauc7B0wDn+278I9eDNTp2yvhb8Dd?=
 =?us-ascii?Q?kUOvPrh5mBRwwwet6yINGiVEhGoLbeNQO3ayup4EEes5P7WJ2OCEr6h9KcHV?=
 =?us-ascii?Q?/xCdyUeSOWwL9uMnoRB0Hoxr9sSD+6zL47+a9JEcvQJzNOPSEyNKG0zIu4p3?=
 =?us-ascii?Q?UqUQdb5E+OvrGR8ehysbmhrG7IL32cAZ4MvIY1FutUOzA4ryDkLhwg5imjO5?=
 =?us-ascii?Q?AV9lmwtC+vtRflIYnW4DHc/3dmtsb5IPf9v5VHgbYLoY+wCRtrhIOGAHZg5T?=
 =?us-ascii?Q?ycp/6WkbLDlO+KaIRpHOULw5d4GajPstW26uz7GatQ0QmNZx9SDrPSp3uHSi?=
 =?us-ascii?Q?o7a9Vw4U42DzEs3Y3uckuUtBCr3efgbHCt5T28AAKBnIhMNM1hlMYzRU0GU/?=
 =?us-ascii?Q?XAqJOavW9zmgUwR8CoPoTghVjstNaoeAgKpd93lcwL7UwoQvZve5PfO2NelZ?=
 =?us-ascii?Q?qY+rUaXnpe+9/XIAKBCx85elIz7nbcVuScDNqDww1YXbnp0s1aRskkr7sOvc?=
 =?us-ascii?Q?pwY50TkEininOAXhh/RhW7mPQymqQhDQk7hm5+OmGWjqRNd4rwQMmKeNWTsu?=
 =?us-ascii?Q?kP8sgJeCdpDquo5e7fdjQ5gAfcSMnDSdB2dU0drsyJ+XkzBr2nC87yV7C7/1?=
 =?us-ascii?Q?3O/nQfDGF1oTzpmP8ru+lB/L6FBEisni3gVW0tk+l5RmDJaHlFIItuzMP3PY?=
 =?us-ascii?Q?YoGzlSG4l2qQedhaoT4jz2CQ7zApb9UtLiQTHYDvEqdbnnZAsqmZYVmxWpCx?=
 =?us-ascii?Q?EvPMCn2XPftELQReRGOYfgKuA7t0C0PwY7MTbStoQv7yP2DxL26obz7L6PEf?=
 =?us-ascii?Q?hrC/7aWsYPsXKB/RKsFws+W0NWLwRKSMLqtRtj1TJcbML6aMuE9IsqPXR+du?=
 =?us-ascii?Q?1l62KOe9ECoggmL7H4mq05KEcEXkmV9llGsDCDMlaRUrfn8i8AzCl3osyDYk?=
 =?us-ascii?Q?xGnzQbBbyIXBq/CuuocVY913g5pe68ou8kycRmHgs4jeU/4nO+rr3kOp74AV?=
 =?us-ascii?Q?YrqWrrwSUqdS+HyWIg8HEDxtIYeDdAkya0a5o91faKLXIJge6KiPdl9kxvr+?=
 =?us-ascii?Q?Hcq/3cVGDXAJWUhRXmwWX+/HPEBopFTXqLBWHT+WN8ddVLbowVj8UwWzR25S?=
 =?us-ascii?Q?LEexlw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2275a67d-2d24-46f5-801b-08db2705a283
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 16:35:35.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwewaDkcHmQYUa6BHK4+gj/67ieczTyIJJeRm9TOD0+YwD+/sF3tDbu1xi+vAa6GBwim0IBrlQm7XzUE7xn2kkeCsDWigZOP931iI306N1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 03:55:33PM +0000, Eric Dumazet wrote:
> We can change raw6_sk() to propagate its argument const qualifier,
> thanks to container_of_const().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

