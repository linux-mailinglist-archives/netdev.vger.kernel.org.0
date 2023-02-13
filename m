Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D412A6943D3
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjBMLG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjBMLGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:06:23 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FE2CDDF;
        Mon, 13 Feb 2023 03:06:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDX1VfS+mLo397rUGh0RLssJJ3nd0OkPmKFxu8hlJOFUD8EZs/uOPhMz44bypnScA2B9uX38XdpExO9i+HbOPal+CxLKICjVwLoqUiYaIxMrEykHg3hAWKk0vxuSEidt9r1LuSGjxvn08xfMOscVLqiK56PTjtLre+e1+l8S+Ik4GtJkh1vo2tOWcT5iEa3HtW+YMKxazNfywy1vStQafEHvKpg4nSVMQuay9i16jWIMbRP7Re5s6hfKG6yoR7sYZ6VjJOz6PUYIvcOxWlVPI0LJWNkR/Bp0RZ4htybdt3VowNq8Q1ZfIiDdvCj/eqr8X5eifG9WVB6aL6oLBMiZ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F57Ao7KGDtpHa3jTjfrM0X1FBCqtl0ZVY3Mp4SWJR7s=;
 b=TodiAkEBDSY3Hn8SP4QcILK6IqV8CuU3Ojz+qTW0V9w7eIN/M4YxxYWBaDwqrOoimrIARmb+35KRQLS9LN3vfIWG6CEX55rOzNlUwImmPsJbAArfLDL+buNiba+S5altu5WnMpyPXRZM7h1PDyTRDSUXppynTBiky8wyUIT63ZvA1f6OHq7kyhx1B+JqBZ6JLhCy5cMNSJawjEoz5OlGoSOnxQ9cdnUFiddftxv0QgfJwUZGH8Dkv4r+/ae6OdHtvtO9ouKR05ijV1rUUvfeseVBAPXZeoA24s4ATCHHEWfepSKwKy4cZ1D/zIh+tSlgO1pUCT9hFoW7FFNPRJKvMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F57Ao7KGDtpHa3jTjfrM0X1FBCqtl0ZVY3Mp4SWJR7s=;
 b=Grd7XAlc3EPpRBqb+ajNy8BLwM/CdX5ACAdV1Gs446AeCwZU6K7RRWZp2ny6vzZN/u1b0XaM7qkPV89vvKbFFXc7huYiKVdXMUDV8gGGd1nyz4SNZWJvBDZPzo9UfWpq3Nu2KVNBIFVsWwQqVm32laWst+A046zu9nUbqJ0LYpMkA/7vciLTJtvmZ1We9uPUrpQPhqw3OyvxznKysT48EmTrO+WqTzrULH1wiWV8oNz4wNyfsSJmkSdGA14kbbHZkGwX+UEr6d7N6H4hYQ/ggtDqyOIvrrkXO6fzxubku4tWqh1jJDaXYsNm7xOudpwz9LoIfRKx6HFCfKIo2iVbHA==
Received: from BN0PR08CA0007.namprd08.prod.outlook.com (2603:10b6:408:142::32)
 by DS0PR12MB6560.namprd12.prod.outlook.com (2603:10b6:8:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 11:06:11 +0000
Received: from BL02EPF000108E9.namprd05.prod.outlook.com
 (2603:10b6:408:142:cafe::eb) by BN0PR08CA0007.outlook.office365.com
 (2603:10b6:408:142::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 11:06:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108E9.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 11:06:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 03:06:01 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 03:05:57 -0800
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        <UNGLinuxDriver@microchip.com>, "Petr Machata" <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Date:   Mon, 13 Feb 2023 11:51:37 +0100
In-Reply-To: <20230210221243.228932-1-vladimir.oltean@nxp.com>
Message-ID: <873579ddv0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E9:EE_|DS0PR12MB6560:EE_
X-MS-Office365-Filtering-Correlation-Id: d0dbbbf1-2d80-40c8-7486-08db0db250f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ceJjXiiZ51FoEr2IVUeOIzT+vQtuB/jw7gDekw3E8tl7wviKnPp+ncHelsQAizJ/25VezuXZxEZRDqKg50EURtxLwOI6wchCFOn5IWGD4npWkAF1E9DCnfXEf1Kj4wduUgDk0gmjGLbvVuE3xAnNmb6s6XoHKjPrBqX1SJ3n8S1S81518KNYdK0IkeE68IGn81BqJq0E/4l6cisb4ph994z+zD5Py2JRzWem4FIfzGtDBpHkcODW4qnfRG78YBZJo2xw6ZlustMcI10v/QG/P70leLHzS206f1SG8QFef6FEkRpH8bNKn4WsykAeadRrf/ISfyxeDcMQ5mgr0ffdp/E3OEJVJhf1fFDKRajpPpFg0q5z969uF6NkbPyezWomQ4bED42eFJlVIFbsA+MTmW8H3s8i23WirNhFKA24eLHbmFImQRBqHN5+13jETpZgS1uh1pBJmar8+Am8/MF4ICou6aYeJxbHSeflQn0j2VHoYsio71C5po0Ts9Q/2Jd6qWFTTVPr/0e/q/HwJEoXPJj6N936o+jtUrC/HVxRgfgb5wkiAFjikRvUEUiUuN8MRyBoTtw0wKeR86cJR19/OqKeN/M3KVpIkVOCff5TCgXmRE0kqKLJH8mJUeBMd3ksyc2puR8FwfVCZBbDHpH1ylmmfk6APYgoayQSrZopld6XgGQo45NBnTwgzKWThvOuKMT3ZCyoi30VD6PsHx8/yA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(54906003)(26005)(16526019)(186003)(478600001)(8936002)(6666004)(41300700001)(2906002)(7416002)(5660300002)(4744005)(316002)(70586007)(8676002)(70206006)(4326008)(82740400003)(7636003)(82310400005)(36756003)(86362001)(40480700001)(47076005)(40460700003)(6916009)(426003)(2616005)(356005)(336012)(36860700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 11:06:11.4694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0dbbbf1-2d80-40c8-7486-08db0db250f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6560
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> +# Borrowed from mlxsw/qos_lib.sh, message adapted.
> +bail_on_lldpad()
> +{
> +	if systemctl is-active --quiet lldpad; then
> +		cat >/dev/stderr <<-EOF
> +		WARNING: lldpad is running
> +
> +			lldpad will likely autoconfigure the MAC Merge layer,
> +			while this test will configure it manually. One of them
> +			is arbitrarily going to overwrite the other. That will
> +			cause spurious failures (or, unlikely, passes) of this
> +			test.
> +		EOF
> +		exit 1
> +	fi
> +}

This would be good to have unified. Can you make the function reusable,
with a generic or parametrized message? I should be able to carve a bit
of time later to move it to lib.sh, migrate the mlxsw selftests, and
drop the qos_lib.sh copy.
