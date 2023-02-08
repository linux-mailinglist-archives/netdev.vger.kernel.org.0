Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004A168EE19
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjBHLiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjBHLiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:38:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20710.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::710])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85821458B6
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:38:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFO4R7w4ysXHYhW5NnnwsZhdvCK00zakcFsYc8iQdXgyGaQEG6xIFmZzJp7e+WJQM7auJxwkNv5rlZZIVefJrBpj2WoAzC/t1vYi5sq3t6X3qOaMYmcKCVI6s4GAsO16uFA+hi/grJOTUCO6BZp06X9aZycgVz1a85/gaZfUI+9gKsPDLr51Fmq0tdeSYlhUuVIdfsLd3Uzutf4htg4qvS4dVcA7wgxhXFqL6dYeqJELR2jDkMj17yD0tHJNHfnwY1TMY1dpavf8/ZG4gJF1PMZ6FP/2Ny0tS1GdrNnjM5eWB920tls9fXIDDObZgOHei6HzptVFresTaxcJXIARWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEjAdpmL/bRD4ix8BHhzdzso/wol92ZTtnPNCGh0pT8=;
 b=mGJEw9jh7iPjFehuVHnkZmRhL08g3TYH3otYimOCAPlex6zHrCvzX2jolV73GWvXBXcB9CM3HzvWko3AMjrfUJpn8PO6Yvyx1YmGtfS5YTD8DP5VVbQ4gGSMlaXhStQVn76vRCfseg8AkN7xNVrQKabvvkRXYjlTAWHqCKg1ruN6QFIZE9DzV7O+cQ/Swt5eZyr+e0JfI6wBRcjyfLCnzaAKEWvA6T5PIaIkIRjSObePMPG89HP8HzhrzqyvbNerbRC/ay9wk3OCWP7LlUm4rUGS0scbsO9FYrjbJ3H2666HKGQNAC7SJQf2bwnyvW718Ucb7ZM0Ff3jSD7FPSX90Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZEjAdpmL/bRD4ix8BHhzdzso/wol92ZTtnPNCGh0pT8=;
 b=SQZeugTZA6Te+Q/ca3KeoLpWIPhmaDr4kYTE5IhopGvMIi8qcFJayjl1TTPuKzqjGZsq87B/2CzZ8wPE5sIuM59e+mmLIimOtjTVnB76YYhOE4iuoxMGyTgYi8GuEKV/UvSUpxJWRx8uRE4w8U5VV9FDkz1bL0CUzz3sBJnpTIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 11:38:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:38:05 +0000
Date:   Wed, 8 Feb 2023 12:37:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v4 net-next 2/4] net-sysctl: factor-out rpm mask
 manipulation helpers
Message-ID: <Y+OJlkt30ADyQa3G@corigine.com>
References: <cover.1675789134.git.pabeni@redhat.com>
 <c1b1b0d0c8a2250eb47743496a9e1b7e003a6d81.1675789134.git.pabeni@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b1b0d0c8a2250eb47743496a9e1b7e003a6d81.1675789134.git.pabeni@redhat.com>
X-ClientProxiedBy: AS4P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 2528b1c0-e155-459d-7755-08db09c8f13d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: asT6V23jVumG7xaN5RAUL9JAF1cyur/zw7VuObPsDCBDUK/y0wplczeBK5OR3TpSq80wXgAhYDEbiwu5XwYiLKByse2Ws9WkrO6djDd01y3RQZNWbBuaNCX/XpGUV0fe6upATP6anTLoxphekdt392WAW+a49vGz6NIlf7dKqmNQUZIH4iSRt+t3POA/Q0/LC7EvIn2a8F67qQw4NAK+Eprj79YTJhCsCsLMzamwd8Y2MJyOuG7fJtEmANvfRHWh2sSJ2VMwxXvBqhnEkYOhGHeXLMf4LrmO1ZoIiaXUDPn6Rnezj2ChffiFkup6k5Ow1nqkqee4t3i5crLV43gyIcgXfWUPyjm69bkwGKQd/8qO4CA8VY1Di8PSV2KgFflUXh0kdIOZcy0AzStMBJO/urdNDboyl94Os7Dc4yVVDAn1jmUcyMXsSVU5DOp7sFowicWn8W2+xMZQfSlPBSSwDw4SfDFaEPJnDxWfq9qD6VQfNM2QkwwMa297prSdd2TsRJFpKiOr/jGIouZur9+mAItdQGK5p/p8A98FGGXtA3YZHNpX69AscSWOfSHOsJpZMcm7bIBNwxiSdakpXpCCQ2euzzS/EyeNjvnVxoU4WcmVDPlT4bKMhKPom51uvJ6BI9/6SGzrAk8+JTmrUj8DWhtWUmbB6OuT/Npv4eQLsPSx+JSMOviJrewxcecPKM+n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199018)(38100700002)(558084003)(6506007)(41300700001)(6512007)(186003)(8936002)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(2616005)(5660300002)(44832011)(36756003)(316002)(86362001)(54906003)(6666004)(478600001)(6486002)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?40sNm5oGs0yw3V61MjWgOHCPWubLQ2MouXg7IQyo7TJxbUbpeHLwcZQV7N51?=
 =?us-ascii?Q?RKTK+uUb6swucq+bytMzgDYBu10TQBAlKFzohW5utwenWD73ylmoaVR64xU6?=
 =?us-ascii?Q?dIxut52MMDbku6acY1xuXp1HOijABGVebjMq/IoiYkkAwPOK7ZKpsotW1oZa?=
 =?us-ascii?Q?xWrB01fTSSk2bNBEYoFWItU9r1DZKpLVnJBEqlnruUCaBygfoa7iJdEtjAD0?=
 =?us-ascii?Q?AekgMok6g0yHjEwoV1y5jd4VB8qZvy+GAbio2rKOleJ6JbcWMJZShIicff+W?=
 =?us-ascii?Q?ZYrI1z9TW4Wwm0D/2R3OiUptcHfdTWXh1vQptEcTteWePtjHIfFvzQEEzWIY?=
 =?us-ascii?Q?Bpftse8sA8G9i+/OvntAiUjmPOXbx6gdGEw/yUYwhjxVYrvUhnAgOgYeoD9J?=
 =?us-ascii?Q?PKkg/RLvxjig3j452smeMMPA2jNr3AS9fDmHWxx7FEo9TSiTRR1EDskq50QG?=
 =?us-ascii?Q?lZVtApd93A/q1N9xuxkZHnDN1YDQeEZX6T7yKw7e4zfXdCp64fNlwgD4Zqyk?=
 =?us-ascii?Q?R9fkVBG3KPp0F0VGO/ccdzyo+iX0dG3hIZ74fRbq1lHkMenS1JO6dsTMFUQ5?=
 =?us-ascii?Q?xcdqk2msNrb5EcD+YFZzolxZUfVHAM0+hTkPeCOXoMh1PC7w/LY+EpSnoz1L?=
 =?us-ascii?Q?VNDoRHqMp+Y3OyI1uBjnwCmy7a2s2EMQhNBMfBYeD56B5F4L/AilLVi3fJvH?=
 =?us-ascii?Q?x3W+aFuiEI/RvVIJFDgfMwrP8HjDhmAPGdMOSfYRlqtvKNzfUeCO3C0xkndq?=
 =?us-ascii?Q?sKZmLBn1RTqn+Q9Sa3M3n+Rr5n53TCMIMELLSSRuJSYao6FCF33jM7tG8w05?=
 =?us-ascii?Q?kmNkp7MboHMcJXCsCx2WUEtPVOJUhuJTgMH3j0MxYjo4ayhUnvRQnS5D/IEy?=
 =?us-ascii?Q?u2zlgfLaKVHl79wKwS8eelNJ6qI9ZiBfZev/0M/o4js5jPLUJZRr66GWCaXV?=
 =?us-ascii?Q?UhuAGfexg+ofE4crHu1KQgRQ8M9tXykOUqfok0sXLZFOWs42YnASDA2mtZwI?=
 =?us-ascii?Q?oFAw/ivTsT/XIspEjLV/Hh2/eJyqFVEJQkxWOY9UYaXvYKjQcpLlM7/Ie1Qc?=
 =?us-ascii?Q?x8BIYmd/x3Ikvs3tzWKT7HVb8hy+0nrR+6fghzTH21t80Q/mjdrvcVYiAkqm?=
 =?us-ascii?Q?oMDuQHsDFbPEwqyHJ7xkhXd3ulqK0WHmlhMNy0ramiejgpwmbexLfqldJ/L9?=
 =?us-ascii?Q?zuHaUc9rhVk0mXZbFvEbqneUduk0vUCWGWwhCZ5QfOeT4YWJwBdMhChq7KkC?=
 =?us-ascii?Q?egpEL5dX18y2JZWyC0FbJoggY21CSdVTG2WeD1s/EnlRnpYQZEPML6ZqPgTA?=
 =?us-ascii?Q?3YX535ISg+au/XNbkXRGYG8NQPai4a7Iz4lCykk8jLNJHDrX8XTxgDz2q2Fs?=
 =?us-ascii?Q?/0akOo4bXLQKB6vA3J4LpmD6lhHmTn/Xc+GZModb+F9dN6dc4FpiDeGdyzyv?=
 =?us-ascii?Q?c9MRRux+U6zcnCAj/uZ3aEaYgX9dPf0COUhdrgPdY9G89y2K1Vsb0PVg8vap?=
 =?us-ascii?Q?8SR98cRLdj/AtqUS7kF14zV9mA6bS6sEblfv62QT35THYWHE0j8GV5MID00A?=
 =?us-ascii?Q?ih2fRBeyh/cCRmdfsqW2bSV9U/DqeU9BqxpsDkNj6usZy0V6bqZG1mwtavhd?=
 =?us-ascii?Q?eckAQKcuDWvjqkEKMMcOuZcuNj+fkJPKSZ7YISCEcOvDhzNrDXYRB3Qye5wX?=
 =?us-ascii?Q?Bv4IPg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2528b1c0-e155-459d-7755-08db09c8f13d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:38:05.0378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C2TbCyqMbZ96ItNSXyOCPF74o0z0n9+2B1kf+V5dE+928m4DIGETA8gTUeFX+SChynynyI1KUVoMBLXU5EIDK8YZ3oq5WK+zsNDJRYAoa8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 07:44:56PM +0100, Paolo Abeni wrote:
> Will simplify the following patch. No functional change
> intended.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
