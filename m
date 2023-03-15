Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A036BB6AA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbjCOOzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbjCOOyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:54:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20719.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::719])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95F9FE73;
        Wed, 15 Mar 2023 07:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGPe0/RUDt6zcWALvcHEiGS5cMZAHBcXpXqRC+MR03iCWFaDpbYomHYbzoGxa3Rv2Jdv7HSa45CfcASPdNuO06a7gV77Y5vQD82ZzkfC+HzQuO24BkdDcMsO453gI0RJhIWpoi+/bj3tEbjTVJArL7rwWWwSE/yMN3aG3ZBd3eeP5qzbvIwS8GmdlY4T75goPnvF1H/THCYvpiZ4+A728LpRNXj+2WmLtRxJ2rdF1LCgRk2vPxMQvIbVF/gM7rPuKMIApSZG8fGN5wZRsun5YccKVaJdC55iR/2IffSzQckt/ihfut5pAqRWTXbM7wMmJUb9WDOOISTGwHpzsA0HpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ax+AQfMMjxrnxxo0UomV6hde8wYlD6iua2wPa53XFM=;
 b=R55bJXCvFkULW6TQDAtob3phQutLopjh5PBDDLXrpcMsp6YdJ/Dt/N/zcdKcRgzo1yZ8KyNS1LMkcO+Qgcl5UJYuBQSRSV5craYUYRs6zbWj5DaA/NC1IOdyFB/cv2+FQoG8RuLcVZlTMoN278NxCSDrKguN78b5wGsAfuKS1wezdqJ+UPswMaYI/0STWC/fM00eQouwGduMuLK3NGFEm9D159IpiIrIMxKKy56Qt2JSIwWJg9FAuTr6J6oEqZU+5uI3xx2ktjR6p7sNREQVp8S4O0I+m6lL2nLiE4vtljY7T7nAARdlKrLjb12CsrVa10dXHnCwNb+V21cIh9+PaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ax+AQfMMjxrnxxo0UomV6hde8wYlD6iua2wPa53XFM=;
 b=D2D5uZ9ivXfWgs3RGvj9hsl6gLCNrfb5yCNK0zUIcQC2KTIRMhvgjvtOa8esl+JIfOWiLsKCiMLcggBoncR2YOLZ/ugNvk8UBnyt6tdbBcXnn5sUu8LkcMSPvS1fNs9hR/X6tMSFbY1pgwND4Vm29BVtqeDBDeF9GisezOaDPg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6287.namprd13.prod.outlook.com (2603:10b6:a03:527::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 14:53:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 14:53:14 +0000
Date:   Wed, 15 Mar 2023 15:53:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] nfc: mrvl: Move platform_data struct into driver
Message-ID: <ZBHb03IF7PzC3hQB@corigine.com>
References: <20230314201309.995421-1-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314201309.995421-1-robh@kernel.org>
X-ClientProxiedBy: AM3PR04CA0134.eurprd04.prod.outlook.com (2603:10a6:207::18)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3af5e3-29f0-470f-acea-08db256500ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iPUQNNfrzLDHeiD5ifUubf/Km+meGD4VhCS4kK96IVqxu7Gr3Zfxe9hiJA2GU1F81KQf9VzsWoIOXTf8T35STJl1xZnK71Pur9M+RKNeML6LJ/r1Eg2BQmy/1LnzC9gVVGuLKuvVf6+iEfzvEEoGTqbQ8JNfXURXejuuiE9jgmRVoFCQPs4lhoh9bvHleND+ODUK7WOo+crDItr9srQ9qYQ54mqxuw5ctdKafTke3oBOe6IDIGv/H+S/IhpmkdMnhPw+sjN5P78vW1lZKP3yo8Nymod7V0lQSOL85HkAEG6oDnxQwNsz0wJlOtLDg+0wKej1hWhRO2PDV/JgC6tvhqO5SIpQHCd3bdmY1uRHs1Ile13BnQ8SEzR1nesMjvsvkderaHMunISQGNLcq72bxAecgQEwQ0pCRGGML7zbwz8emfO6cENIuwAENfjQ4pqoYnY/PzxMu/jwK43kKzsZ+aa0tTydwxyYdkpbIu5TnfMg87bdl8PKjqscoHVfzqDy10XFv7arM5o1kzh9mc6E2/lPENrvbFoUkdO3gshLSGaUmniTHefg286vFDgaZ7BD12R+ugj8VSDXZ8Z0Ve2Ibnf5lq3EOeBAdaNKIAg5lBbqgBBiobgqt7cQ/Yyx2oWC2Nokp/PjU85DpyY9ISgBxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(346002)(396003)(39840400004)(451199018)(36756003)(86362001)(558084003)(186003)(6506007)(6512007)(2616005)(6666004)(2906002)(6486002)(44832011)(38100700002)(316002)(41300700001)(66946007)(6916009)(8676002)(66556008)(66476007)(4326008)(5660300002)(8936002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RJEPaCDH0mVpoX5pkW1kktM/UllDHHhE7i3RdJDImTuZIFr0ygMltg/R5jgL?=
 =?us-ascii?Q?KDySk9OVJPyJq/oRNcknuIi/iKkEqJus2LeO9eK95CFIEbZEecgYVs4N3vTw?=
 =?us-ascii?Q?aZ3t+2+VIubpBIuR9fvccotMVyIqadcZIYTyMKO7QwduZ7G0SWxuIqUbXiAz?=
 =?us-ascii?Q?wn87jzImFbBJclgHgtE/1IVE6jP1HeBpokse33vgc0zjDBTT1/YIhpp5X9Qu?=
 =?us-ascii?Q?B9C03Rzj8BzNnBjieZK1nwpMh6ZyGJslcare2lj4+F2FpLmVnFhPOnxGjxsu?=
 =?us-ascii?Q?tZwRCWz/rl5F4zQZ9v2XjUoRsv/e7cUA8wrwaQoYo/fuhf2RFZ1Zq4AdjOMo?=
 =?us-ascii?Q?vVMqNK7tFyTDQ6BDF0xE6/U4DFYI836z86pu+p5BWy5CMryNGvfg4Cfsx550?=
 =?us-ascii?Q?T7CuikcG9eu/BlT4IiKADSbz4mXoH8xesSDWel+dDZ8TF0GeGGQfVWnxdMUj?=
 =?us-ascii?Q?jn0WSMvunbcBJQjRmLC+pbwoSO97FTy0vcll7MTpmKu7/iFigACo6URMcNnV?=
 =?us-ascii?Q?uylM0NK4fP6JTA5z5hGsjK8ZVgeKZ18cINJLojq2DGvO1KuGaIUY93HF4eUY?=
 =?us-ascii?Q?hrwcnKWnMR2JHyw31BSbc9+pNeYu5i0/5s+/LjhcD8GyF3NwKu9fQcFY6kK6?=
 =?us-ascii?Q?A0H5XgvqmqbrMFRnqU8xAKNs2z1ip2TCjutJIrk3f2UOk+5YGyPO0fDLXEK4?=
 =?us-ascii?Q?g/VjQOzGyGSGym+PEu9OeCS1xMgSQG2/Gh9ntSKrNOuR8UxytUDwqvS2idsm?=
 =?us-ascii?Q?phc6JJtQll3Y7uQzegZLqpis5tIW6G3dml1rRSTrTGS5fltYAdrNlb3KTT1O?=
 =?us-ascii?Q?ds08Kqx9/wRs0LFEl+VK3OUFfuMTJ/VPoFocdf062dyiBcu6nPeVpOvgvtlR?=
 =?us-ascii?Q?TLvrY7+oMwY1QijGFoDZSr4ruVEvLX4mE2yh+bGZdRZV7Otx8By/91GFQf6R?=
 =?us-ascii?Q?LEyGf2Eho41rrAFDeq4jk5noSLvRLhly+9elJiUZK49F1S+JpBt9oW+mb+Zk?=
 =?us-ascii?Q?4OFlMTavSd/Ti3WHYUqV+RAzs/ElDUkrbWDvGsoBU1k92pwehoALdcZqcX3Y?=
 =?us-ascii?Q?n8zFh4T4ldbmpUg5SoJ4546O5xshBpUGBspPT2Mvk4zSfEnJnaazU4wd1WdY?=
 =?us-ascii?Q?Q4PQ1uZIvzaMggI2sJ/LVY0497iAN1Odu7SUqi1vuGSIaU14P//rzdTTOlFH?=
 =?us-ascii?Q?VV6MXADU+21yCUtlwu0LKtP060yOARNn6kVLHQXZxg4uZzLNjdWSq49USd/E?=
 =?us-ascii?Q?CYOmENO3KkFyviIoDLyBp6bmTmNA75jU2c2sNLn/0etbV7nwtruMH5h6Dqfy?=
 =?us-ascii?Q?+LFwKehyJTC5xUGG4Ln7QU2K9tg4q2sx0TvFMRoz7atnJMQZ3xnceaeDmFVK?=
 =?us-ascii?Q?auKUYws6gzsAkkHDLAhVUIqJvjAPhDK3n0cbZEXcnzqYqAA5a1pHhsxM5gsx?=
 =?us-ascii?Q?dIZyDyQhB3/MP52L/eEixwA/NETfxvKLMNUgy/2zWSxalLK6Zpw1KGr7Hyv0?=
 =?us-ascii?Q?ghhy9NhG8qDa0xZ7rpN6O9c6JYKQ+Nu7KS76wALSr0KbGbcoM+6Oc9OHRsqz?=
 =?us-ascii?Q?nkRthLQUW8bhn1wA36KKdoMipF/CVWt9xZ+Vg8xNXGlIDV4pv0Tzh2cN/ekW?=
 =?us-ascii?Q?VRDUDXpRsH2X3levMi+8X97lyhuyvwTLWrMrbBLSg71T+3WQZ6iS/Fr+WCV1?=
 =?us-ascii?Q?MvdBiQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3af5e3-29f0-470f-acea-08db256500ba
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 14:53:13.9402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gYZDkVuYmnrLqoYlKF4jR064zQnVuJtfpHbdx+WvNye+kBdyibg7ixlVyXX7gBUvAovVQtwfHVz/49SUkOXFD3n/jbX82Y4bYC+rwtEYTF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6287
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 03:13:08PM -0500, Rob Herring wrote:
> There are no users of nfcmrvl platform_data struct outside of the
> driver and none will be added, so move it into the driver.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

