Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AC3671D76
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjARNS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjARNQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:16:53 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2094.outbound.protection.outlook.com [40.107.96.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BDCDF943;
        Wed, 18 Jan 2023 04:41:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMtugwptNk6Ov9YYiOVgs/GPD2HAcEHvCP2a00zY8j6bEV36tnZXCRMDrN8L1AwOz66OBIZi8soU5zhB7ZXsZWnkWxvSFn0XJNlB3xm647O9PknNO8Do1SSqK4nnxCI/PaWhoVIsI3Drko8sWzgw9gOM+7OGgydaCQGrHtFC48hUsD+c9hFebo793jcK5alAOCbuYghXDh0oF1Rxi6wzVRzMfDbUVpcDv/2GxNCND2NVA7/bH5Ui8XbryTq+BDA9jX7vH2rIrfzSK2R49bymfEHNxc8LfQfvDTFAPuVatF3MoSasj/0Hn3iFAyjRAP9z4fDZ0Qr8yOjSRBmsQ8RLqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TgtbKWvGOfqp3LG1vmnP+VHWZMgYBokvTLUSB/Nnss=;
 b=HySOPlupEcbtf7Uts9b9kc6rNEONX6IBnHXgN4c8q4oF09bTk8MH/h2QNr7NOywigt/bl/oFgSyWEDeuU1bd3iP+lFB+4QhVO2ChMCDztzSxM179W8Bp5QYjmUkms2yPUHnTpGgvdcJnkFXfjZj3E1FSkkxJ+86Zh/8MxSh5lq+WTldyCh0gF81HrhIX8PpHJ5BrmqCdkK1S4Wpsw2+3UaLPZiAgdunQar5SqpDZ/kG27Lr6nfPi7j8vd3ZHOGd/OqDj1LfUpdeNaBfH+2JEfFKxUzHLyW9eQUZDLARLU5zMVWMaCsLKnSug7A0w2VeJ5Ck1dQnROwrTGY1jaBFhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TgtbKWvGOfqp3LG1vmnP+VHWZMgYBokvTLUSB/Nnss=;
 b=RObiTAJQyht3JNMoGsZ+PG692E4gqMUh0BlULmrNk33iuwUNVY/P2d165TKMSPKGKg5X4nTc+ozoBeB5e+PpLkoISYoLogbbkuBJWu1gedB7GPpjujfOg7aRxzALl2kufLxKnVEQdvJge8huiHSjbLA80ZU0dmiF3zOInwSmqts=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5659.namprd13.prod.outlook.com (2603:10b6:a03:402::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 12:41:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 12:41:21 +0000
Date:   Wed, 18 Jan 2023 13:41:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jerome Brunet <jbrunet@baylibre.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8fo6qx7LnXsJN4o@corigine.com>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
 <Y8U+1ta6bmt86htm@corigine.com>
 <1jk01mhaeg.fsf@starbuckisacylon.baylibre.com>
 <Y8VWWP53ZysENI7/@corigine.com>
 <Y8df4LRfPN34lvP8@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8df4LRfPN34lvP8@lunn.ch>
X-ClientProxiedBy: AM0PR01CA0121.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: 3374fa1c-8ffc-480b-99c0-08daf9514d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atA7GDXMmt/4MQviFpEabMZduD2/3t1kfWArZEKmeuLuY/QZW/Zli5L0z8q/atiUzyTZY6zXge7JimIp/ShMyTM0KvyuDclG3/xQd2mBr9lruehxqN2dpyyXOX8ID5DJwwWuMx5BXOBHWA1gFGeyHDhH+tNI1uhPDfHy4AxOgMxmSKqPzKFEooaqXovRyWP6eOo8lHe7vF09bohcqpf+pCJDTr26SF0PyE4nWgsmpJxfgVVqmxRRqtXqgEScbgfRZ7XnqKf4XcnTXckavX3gWi0vMJxHfIyy7PckDl0WpWZpR4sGtHDYn98rV55vXQkr25oyGfxtMDlSJ0WDJB7nEjcQG4TORmkXIxmpqMPr2xfKkuvjQ3Qagko55iB6QEL2sc+tNVbyPn/0SqWbhvlaQFz39mqmKUDr96v4vL1EdVqUFBswi/0IxnL/AhO/ll39yKajji0+gw2owcNd+b6Eg1Yxws031U6oHc8YNn2c9gZ6NNoB/dXPbeJQORel3CX8i9IM5Dk1c5PnZQS1k13nNfXLHtXrGM5eEr0Gq2supkCU8r/W+FTbxwrLTTcmWMhZiGHbAnLNFucty64zu0HpeiN7Vr2apbq3dfKMmo7QnAYHXLv78KTkSEE4ukgpGEIxH/jD/i6RTJrEXgnRpzCCfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(346002)(376002)(39840400004)(396003)(451199015)(86362001)(44832011)(66946007)(4744005)(66556008)(7416002)(2906002)(8936002)(5660300002)(66476007)(38100700002)(316002)(54906003)(6666004)(6486002)(6506007)(478600001)(36756003)(8676002)(4326008)(41300700001)(186003)(6512007)(6916009)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O1tTq+ye9ukHlwP16vBqLsFgDMQFMYw3+MFRKr+LEUYvUtaT5AqWxGolhP4i?=
 =?us-ascii?Q?dXlM0Q/HJgO4gJa5+4ntIzDUozJOYSoG6Pb8IlMs1UDHXsV647oWGVewsmTh?=
 =?us-ascii?Q?leVrvlibE6B/IkWPy0VZZ5jSO0CNq/QcP5UxIlEovVI6nomc/Tkxn7f8JJE5?=
 =?us-ascii?Q?iZL3W3wBNiGlb9QkCGXOEFncm8KAes9sQg2ZzIqnVp4ahpdCxpuFzKGeWEFG?=
 =?us-ascii?Q?Flq7ZEST9VX0RaK5L7+PsKPFDAUuRYqcGkQgdJfXshxLq2ZKj2p9MOE3JeJC?=
 =?us-ascii?Q?gVx6H1VZmQfOj9D6cHA7BmId5gmZu5xLDP80YpeodaIRUfFitOhT3jq9rx8S?=
 =?us-ascii?Q?JDL5wkUh1R79L8br8fn92nUYLQUFXJBqsQEKLty8w1H6vYjq9Cre4O1HfRp2?=
 =?us-ascii?Q?haEitAIzy528IVRdAtipPru1HqU401sopmIcU95gwo96nwWrg8QlHbtOll+A?=
 =?us-ascii?Q?juA5dzOg7iViX189E31F50ula/ds5RcUBO2nbbdFTYRwBp0LpT+LRvTDBDmk?=
 =?us-ascii?Q?Mu3WAOnYmH8weiQhJ0pBWrWh0jkN1rIGHPfAyIgF76zjtCjKn3qz5Y7tNFnF?=
 =?us-ascii?Q?EeIGCYmC4d5TD4a8lRvcr8Sd69QHw79ZvlrIxZeaoPBEKVcwVA0ievaTNoIY?=
 =?us-ascii?Q?xP/cqDkoUlePfJIsQDOSPFDcQBibmNk2E6KC8gChIx38XPXQTZJ1hWPirqiE?=
 =?us-ascii?Q?2qYVFgYqV0V4JOkJDPt0hjL+RHdGS78oJ1ypukKGeBGmz4JZJKDK6ADnP0fs?=
 =?us-ascii?Q?OTkSOmx1yPs4dN1vhEqJuyhvboIcGPER0KLU5JTYdTmS7CWD4NnkB4ZGjYM1?=
 =?us-ascii?Q?P5GqcyJYhGcMgQSJC1BsZZACqotBO9M8lJUrB37A64QHtgKjKC4mQD3U06IR?=
 =?us-ascii?Q?WnlPAHlQw5IVEhvx/nGsegKrBJQBfGYPYfIg29VRgZFYm/ni3Y0+etvEaslp?=
 =?us-ascii?Q?27Go7/43laEEbbV2ZfZ4V5ZapEaIGhqFFWl3W7eSNHXwDvQ81rJilQ5c26XZ?=
 =?us-ascii?Q?/xu2IUPPyw1ytwFo5pe6wgZ4HgdTmkE19QO0STrDWOBGEOkDuZKv++Q8lDcO?=
 =?us-ascii?Q?icuErJDgDjgqnN6bUwAJ7limHHm8D99w2YE02Pyxejby0mkcVxBa4ZGQ2inX?=
 =?us-ascii?Q?eXRF5A11j497PXKEAj4pzDr7a21LZVpAxA++HyU8RTQ+tyzVK47i4ue6Sy6r?=
 =?us-ascii?Q?w5eZ9/yfoT6Vs23DfiDS6amyjP1CVUfeH6GR65ccLyWjPcQhsxHKr1uJju6y?=
 =?us-ascii?Q?Y1sqf+d3aN791wSz/P71BMaolX5hCperHYaYDyHiiALD5lbcgnjeRycyU+IK?=
 =?us-ascii?Q?5WAa02bUZus/IgFFRd+8SCFUpoqGJrpN2MhaPJyw7lNPk39Sdb4zXXjqYTV7?=
 =?us-ascii?Q?31umLQ2i8r179z+6+2cICLOndI6z9tsCvyvXgBIqzsIJ73bSSwRIAijWio7J?=
 =?us-ascii?Q?94F9BG/m2izc5LuhhbyzRYjfZAx2X7ZLwn2HcgDIixaBDq+rHN3rMdHcozWr?=
 =?us-ascii?Q?ZB1ZCf/P7pOViQvbud7nfMVXxexaXJWv7rXj4WC9aC5ytQMN4hbxu0SZwxvS?=
 =?us-ascii?Q?R6p8pgq3qCFLVDlkxM4ZmwjXt3nqj2WAQVZRF0lB6GDieECOBPbVGbzcgkcn?=
 =?us-ascii?Q?NIx7kub8jsXC7GjM7sSKZ8yr9m+JQgatyvnZzhptV8Sfqi5AjfLy0QoIMnEY?=
 =?us-ascii?Q?V4JEkw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3374fa1c-8ffc-480b-99c0-08daf9514d16
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 12:41:20.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IEd/OgkS94qsK8qfO2kmww3hy9cWUVraSrn1L4SlNbslvAX0JO6PNqs9pXve2AT18LmbrGaJCD2x/jLvQCUk548r//cHs4mqW9OTfFV6gBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5659
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 03:56:32AM +0100, Andrew Lunn wrote:
> > > >> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> > > >> +	if (!priv)
> > > >> +		return -ENOMEM;
> > > >
> > > > nit: may be it is nicer to use dev_err_probe() here for consistency.
> > > 
> > > That was on purpose. I only use the `dev_err_probe()` when the probe may
> > > defer, which I don't expect here.
> > > 
> > > I don't mind changing if you prefer it this way.
> > 
> > I have no strong opinion on this :)
> 
> dev_err_probe() does not apply here, because devm_kzalloc does not
> return an error code. Hence it cannot be EPROBE_DEFFER, which is what
> dev_err_probe() is looking for.

Sure, there is no EPROBE_DEFFER.

But, FWIIW, my reading of the documentation for dev_err_probe()
is that it's use in such cases is acceptable.

Anyway, let's pass on my suggestion.
