Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB19D233030
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgG3KUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:20:40 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:41794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3KUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 06:20:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6wcaWvH5ELjPNNYIgeo2Um5G7jLmJwaisFyrTjDXnDEto1aSCxgwje/8JWCDJWSp7MjWw6y0RDNKYsro07E1aDUdYGySG8IibQIirvx2Gz8nQTpG54a5etkYX1NLxbViivc5N1zjDGu9C6YQGV+VeqYkhSB2IfcPxBP8515bFw401XcaTP1mfcFI3zxcEnktvIIHPZT2YJUBvBpRYAAId4LZTA//0wEkis67W0PqwWJDaHpX/0cjqoFKfWKwk2oYxgQftcZovI1gw7/4E3NuUl27fism1r+q4cdP439GDgJECiE4XUYrQijBkMS1MOwqoLSKYUbfkXjjRssw8+IRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUfAC+9u3d6pNq2PvF5RB1HvXEpNNo9m3wu7QuQkZ88=;
 b=YyPvzJ7xuqcIumYy1jCHUv1CdtQCfnWRz2xHxXgYAR9lEyH7ceg6F74gcG2VkxGTBXHtWxeYqGZrFG0YedII/3IS0k4fbH5GQve19x/nY80ncdclpZjJ2eSsPvAOQfE5uLB6VbxjQGETNRRqIuDJEasJWMYy1eYSaxUr5lrvArZ0yt2jGyvH5Q0pZX+uYHBTrh0Vkqr7eXgiYTAlOHz97oewQ7ORM66XdZ1vr7YZGAZvu9YZv0qNBQM1pqXjTC2Rqq2ZAr0eMlF72kSOBnXc8+LYnmjFgGISpwrFP47CUa/kYmw0/wY2eDFXb/o9qyHXJ1mp3bCjPbZ4TFJYMeHX3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUfAC+9u3d6pNq2PvF5RB1HvXEpNNo9m3wu7QuQkZ88=;
 b=IwJYSlrydWddX3RE/jqVGmtRw6O8v/NApHuMBLV2hidMOOoOoskFiNfRB7qhEgKwr3X95ZU2+v/y+PmTAHaKh/Hwps2XT2pt+V8rYJU1quS/J9a83qSAQScYt/fQdQQ8AZEkkdecUylkA3OcCW73t2S/6D8OVkee/xZNhOYIgzU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3036.eurprd05.prod.outlook.com (2603:10a6:3:d4::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.17; Thu, 30 Jul 2020 10:20:35 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.034; Thu, 30 Jul 2020
 10:20:35 +0000
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-5-kurt@linutronix.de>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-reply-to: <20200730080048.32553-5-kurt@linutronix.de>
Date:   Thu, 30 Jul 2020 12:20:31 +0200
Message-ID: <87k0ylgv80.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0177.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::46) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR01CA0177.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Thu, 30 Jul 2020 10:20:34 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9f86070-db7a-41be-8749-08d8347232bd
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3036:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB3036FA5977AD411E83154797DB710@HE1PR0502MB3036.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jJBfpv+5oE5xb42ypMGqeLiZH/MpVkM5+qtqreolSzLAOCmuejwZ1so8WQANLlA6l4TFzrFbAHigMol4G5fpH7HQfjnQSaoPpkKK4HNPMc/aZhN2VPvVGSfwroTABtTe1cUxIuo6q2SIOeKsdNkyQxxA5qGQ47XIyfDWzSWDDyYLbfWy6OV5yUG+D7ckJKQHdhl3ENUK2dTuv/Rb74IkvFPMBaz+hKHlr6mOOc4pQIKcuVe4jaZVlupBmSOlbSQ44wFlVSrrYzkar1CPQA2wozSXxTKPIW19fb4dOhoDuqqIVOEVE2BoSgvUwsc4CCicWGio6xIkQflMds5jCONntTKCvVZe7Yg6KkOw5NK2g1lLoSohpa7caG+WP0sO433
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(956004)(2616005)(6916009)(66556008)(83380400001)(66476007)(2906002)(66946007)(6486002)(558084003)(6496006)(316002)(186003)(16526019)(5660300002)(478600001)(8676002)(52116002)(8936002)(6666004)(4326008)(36756003)(86362001)(54906003)(7416002)(26005)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dfZhJ0fjg09gL07O8DeVm/Fxs8YCrBBTih32EFg7fHp39yUTCTrBztWraJu8ZN5eIkH5e8dSrQZeVghlmkE3BgidNSpaPTqXl7f/QhoWP/H6CV0ZK677SLKotx9jJWm32+7MxvezXYlqkNn16PD620wpiDOMqnDfVCKgGneCbOCvqtyHJmC1TnzuQ7chZhftNb3WNWVWACh+/a1wiBz7eZTsiy74GRz/44L7Mo7Nbb7g2CQMSY7JFBDBmsQhARmY0ji+9fuMW3HCeyEUJhj5hUejua+h/TXT61T5aW9ec2egvuPl3j2XLIIItq4sxZ78A4Y7FYHr0G4XauyIijomNjex3UA5X6gzp5Mn+QHz3rt/D1HSWdmK6ulqIhF1RQcmv+UNyeywWoPwfl6IzGSOaLmYsugNamapQ5WQANuQgepRYl9cuR3OuJFOaMN3DlGUR++VgKWQzGQTv+0XZzI+8+cCDpByAYgkUXsyBf6Z+YGNcl6b7a0dwKg+B2Yq3WTzAQyuUtAO733R5ioj1eseEL6/RgxULIBq4MhqAC9pX2TFT4yPH8TP0PFJGWKM9Vhvs+qXVm6cOjPsjhp3jB957eD3NrhOdKQXHEPfLou6BMaTn85f+UF1UzN6gzNBuv80FbxQlSRmZy2OaesTlsdY4g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f86070-db7a-41be-8749-08d8347232bd
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 10:20:35.6502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SRIRz19PdHEcvVSWVr7H+AEKDdmHf7JU5wmJE0ZDr+QbXX2jt+efUCfooWgYDwXwDAbuWVYVZVapbNL7s1UKkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3036
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kurt Kanzenbach <kurt@linutronix.de> writes:

> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-and-tested-by: Petr Machata <petrm@mellanox.com>
