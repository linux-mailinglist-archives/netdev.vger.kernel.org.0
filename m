Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFF46BBCC2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjCOSye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbjCOSyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:54:33 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2110.outbound.protection.outlook.com [40.107.96.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D099765466
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grStDsh6vuSpZmhf9Imgx2orHYCyMcgLe1GQs4haSe8io4BJ41rL5VBGpC9cHtY1CmArp/Ywl9zAHWmZjbYIL+sEYxvvydEx7U9cLkUUbWXKs+M06Um0sSwmX1yZ1vg/fGJ4zGeNenhQLGGQ6cGmH2V/5Z4/v1jdWcATWcK2LntrAU8JPGno5Dl4ScdRDut0q6iZhXoGVQSj3i8QcLeeHDy5LV1S0sFHXzshRlvu5iMDqWbZXu3IRzE+0BDWwqNAbDWONbKLdFGk1du6hZ3qa5hirc4nYHIB7j5sNhETSBorMJez9tDs3ErXmznuF78JXGUTuOBRfxfil/H1luZOTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0pdqvJocMFOA59yL/eTIFFlhYdhe15/f7vEwJ3a2HA=;
 b=MhDJvXbcq/cCULUqZGuOaUbGNJ5ngbbqeurcrtrSRa+IZhjtFRkC21AQo32rX1dnkJs9y2HuY8gj01Ha+Ul8doTr2JsyiQCYKkn1I9UriUJ2RSStK4vxMYiOzqhibA/7HPKgk9FUrm2M5tPBiBLd2aKNEkrJHxqmLGDs726uyoE5yQZPktchPXsoD25TE4sbxITelVDIDIqEkcyewIJih92MMrHsIkaKx3AJlRGSgBzMFaioso+aRIdVXG0PTn9ex9zg8Nkj2ghpo1uFfojIf99jHvUiSReXsxOK1L0QSJwyFPKVxDl5IBNbWBwCaSyHMUtNp/P4ZkI6kCuWVhtnow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0pdqvJocMFOA59yL/eTIFFlhYdhe15/f7vEwJ3a2HA=;
 b=m15lVhkiGJpIYFUID4eEHL81qD6uuKwBs6y/M3jCCJBqLF6//QATez80mbTu/JW9pm3PpHZSUa9UPdzbP//RXrSG8SB2EiZ72Z5hL+MKkXGtZUVqmJ4RMjcVIO5T9ax79G2kbKunBk8pK/zKdUt4Bp4Dw5ArmS4H7MQQqJ6rcDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5584.namprd13.prod.outlook.com (2603:10b6:303:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:54:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:54:28 +0000
Date:   Wed, 15 Mar 2023 19:54:21 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 7/8] ipv4: raw: constify raw_v4_match() socket
 argument
Message-ID: <ZBIUXUt9u/Tj1HGG@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-8-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-8-edumazet@google.com>
X-ClientProxiedBy: AS4P191CA0022.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d62d20b-f1b1-4292-2192-08db2586b408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9KnJ4vpG4c4MTI/MXypdRTBGh1HjDE4erC3ufU8RO8jaL4X+XAJZjjIH1PGcurQKH2G5jLcST1yZVJ567ZLxfF8aTaO6j77in4oLj18ePndin+mdOe3o2MySJwahgfA56VXzIP7OUAY5kF78cqk2HxigEIET02pcnvfTHjaYbwnQsY/9cBnkGbjC2eVHNKxFPuVUYwCuV/lUePXh7n6IcDLRIVHHUIh5iAxpvROKUG6cQAEDpketAMWpvusc8rkxHZXzm9BwckgjczdUYLopxrxqA7vbWSXthB+Q/7GdCqAnBOTqt4tb1uHLC6igScAw4QRssscJqt1wUTzpcAHp1wQMzJGgiMQDvKFNGXpf2JEmPi2JE+kif+A6w4E3KRDjjQasyIOL/pPJapmTyNt6/Y9LkKPmtEQsh5lRua70iVuvzgVc1EFaOwG48x7ulh/Ezz2YaJwSE69e6CAzLBDmZRk69o037yUfylT6mYuEPaQ9ME/Xzv6BhvRK0jy6JPVUjvQAp1qqsf+aWB1smnk5uXnEqM6qN3w8Xlbg5l062VyfO8/qX6JP1m4qqXSmt838qL0fXjFVZ0qJht0yeJnzx9BbemN9ZuITBGNGmbt8hDotOaeWHH6QFq3982M0FvDMlDH3g7XrYe+B8uVFw0AipjXCcCkP8CFuIQ/OYYNGnugmF5/po4w0qCm9htvOWrn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199018)(36756003)(86362001)(558084003)(38100700002)(41300700001)(8936002)(2906002)(5660300002)(4326008)(2616005)(6512007)(6506007)(186003)(316002)(54906003)(66476007)(8676002)(6486002)(66946007)(6666004)(6916009)(44832011)(478600001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9FdJQZze13fcy1hx7RTjZIfRzMt9ue3nY1Z+cJowBhMUHDPY8683XzVF0OrD?=
 =?us-ascii?Q?HGDIved7FKH4QnIo/wH3Ywd2myBlUcVk1KqlHAlTs9LnBwa+INFgTQGtCvj0?=
 =?us-ascii?Q?td2AwIhL7rBwVt67EiNnH+EcURpRRsp+mvx2ji0Z/Cz4CKewhDwpyHIGg0kR?=
 =?us-ascii?Q?mfNtxbsTst2xFBVJGbCUuM6bUwMKzoQ/vwKgpZiMmLls49AFVoOEpxngO77X?=
 =?us-ascii?Q?K595mjaqGlAnqtRXGZCKuOw55PPdoc8ZnWjU9jasYiffUMVpm6SE0yiloRgu?=
 =?us-ascii?Q?mYPbtMgu7kCVO4bu/nhUkA8+DEofFDuA69II79NMviEpuqFuN+XX/IHwRuDu?=
 =?us-ascii?Q?BjMt1RgIFYKBMMUPmMYX4g0Q5tJH7I1TN07u6TaPGz77a1nmp5s1vnT/PxG/?=
 =?us-ascii?Q?81sjJ6eL7rNoT7TJFjk/8BX7jQ5xDPApPGMkgL75Bx66tVXlia5ntXaIrwF8?=
 =?us-ascii?Q?dXi0+TCiXz/a56pPNxzm4pjCSnRiAVh2pIdjUiCi+0QfyM9ezJqcFMD++edK?=
 =?us-ascii?Q?PHywX2wiIpMO20f+MkqEnr5Dg2L7xMTwz3BJ7YogOuyjDgZT3TcvoJNWH2YG?=
 =?us-ascii?Q?8OKQoerxtPNMrELMnXA7g2MfMzC+SdZEtDECNB4TbzTVsTLDwJMeF+m7Zxlv?=
 =?us-ascii?Q?OJXyBpmwcQfIiKYHGVZ7bO23qUwP53hR65YOx6SzHEso3ssejzyQ/F5jrPki?=
 =?us-ascii?Q?SbD44GbXqlx+UvDxYow4Jm7JCVnY3pf87YLq0PUkLC80oV8YB4KVQQgQkzRs?=
 =?us-ascii?Q?OjWpDq+IDELgVwAgNItSzqjPmaHNvT0+g8sxqeWkwOev6fxBlJLG/ogeE67p?=
 =?us-ascii?Q?rVj2j6W9mgC6z1X2vyyRvtF5kTFgD6mZy6ac85gqbzqoNsUc+Qw2d/j2KAxi?=
 =?us-ascii?Q?VyLGYApI7F0CC9HzstcLRi5p3hxDp8FXcNoPMOKib5E4zsTawDjq/7yiQQlL?=
 =?us-ascii?Q?Mw7f/AMu74HqXcCO3le4+TTa/y1ASdnoFlfwwTKoKPrt2xggwfk8DApuVNGh?=
 =?us-ascii?Q?n9d8DQYrfJHsjO7hvpPDSfsd2fPJ4oMISkZpqFnSiQz9NvQ1mpLymMRhzmzx?=
 =?us-ascii?Q?RgzOFHwY6JxCTqk6tthBLEAFz2Z/QXwIiC+YVfoxVvR+9mnsBh2oENtmeoBT?=
 =?us-ascii?Q?UpOwJHBj87/A+Ihc8AyCrXs4LJuBetYGjXWTwDLXFCl/CVEHWBnqW5OeINtw?=
 =?us-ascii?Q?aHfn/qFEjrx9hO8F0zOVVZ1/3/mA6mvXKdFfnwaILHD433xTYr2ZwNtj5bUc?=
 =?us-ascii?Q?kvs9VtWYkyI6IVfGS1BEgUM7a8rtPUSvVSn3UZtk9ToZLZgbdCxp0r0nAjLs?=
 =?us-ascii?Q?iaRWzW9rj3x4oRy4mn0TnlpoGDaLU+2FNyBR4N8AO7Uprr4bEbEX+wlvW/ri?=
 =?us-ascii?Q?9Dj61RSwyjrCIb9nwQ+p6vnvW7t8SsmrPpCIqF7236k5gVRt8IIXl2d3oxC8?=
 =?us-ascii?Q?SjQSnqsMzfWQ8kdf/fxE0AFrO3b9l+xFrwlHuAWxqK60CycHnjkuw0h7yY3L?=
 =?us-ascii?Q?tgsgZv0JxoQpApSc2nCBRb7aUKia0F6OYGCo3YXFQ7QpOjkXHWLtl1SNrhnc?=
 =?us-ascii?Q?BZnT8hVkWuHQpZo+9qERDuYlNfqC9DqltUzMsHRPNH/vdl3x1xjCvchnllcJ?=
 =?us-ascii?Q?j0pahGhmD5hbq++h57DtYg4nZz3XyJrf8ywjCGO+ULev+c5NcNX5Q9M0TvVb?=
 =?us-ascii?Q?fzVchQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d62d20b-f1b1-4292-2192-08db2586b408
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:54:28.1208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieqzG3OqDPhjjAbsebSPEbJkJEmX/jpSfEiyUWjUe0wb/mNNcNrnsUdKqRQcqpydu79pFJC90DRH98kw0BG6OoXFZKKbfn52U8hOB/tBPvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5584
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:44PM +0000, Eric Dumazet wrote:
> This clarifies raw_v4_match() intent.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

